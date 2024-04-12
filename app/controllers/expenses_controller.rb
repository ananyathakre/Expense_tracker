class ExpensesController < ApplicationController
  skip_before_action :verify_authenticity_token

    def index
      expense = Expense.group(params[:expense_group_id])
    end


    #SHOW
    def show
      user = Employee.find_by(id: params[:user_id])
      Current.current_user = user
      authorize user

      expense_report = ExpenseReport.find_by(id: params[:expense_report_id])
      if expense_report.nil?
        render json: { message: 'Expense report not found' }, status: :not_found
      elsif user.admin_status || user.id == expense_report.employee_id
        render json: expense_report.expenses
      else
        render json: { message: 'Unauthorized' }, status: :unauthorized
      end
    end


    #CREATE
    def create
      @employee = Employee.find(params[:employee_id])
      @expense_report = @employee.expense_reports.find(params[:expense_report_id])

      if @expense_report.report_status == 'Approved' || @expense_report.report_status == 'Rejected'
        render json: { message: 'Cannot add expenses to a report that has been approved or rejected' }, status: :unprocessable_entity
        return
      end

      if @employee.emp_status == 'active'
        @expense = @expense_report.expenses.new(expense_params)
        if validate_invoice(@expense.invoice_no)
          if @expense.save
            render json: { message: 'Expense created successfully', expense: @expense }, status: :created
          else
            render json: { message: 'Expense creation failed', errors: @expense.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { message: 'Expense creation failed. Invoice validation failed.'}, status: :unprocessable_entity
        end
      else
        render json: { message: 'Expense creation failed. User is not active.' }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'Expense report not found or unauthorized action.' }, status: :not_found
    end



    #UPDATE
    def update
      user = Employee.find_by(id: params[:user_id])
      Current.current_user = user
      authorize user, policy_class: ExpensePolicy

      if user.admin_status
        employee = Employee.find_by(id: params[:employee_id])
        expense_report = employee.expense_reports.find_by(id: params[:expense_report_id])
        expense = expense_report.expenses.find_by(id: params[:expense_id])

        if expense
          if params[:status].casecmp?("approved")
            expense.update(approval_status: "Approved")
          elsif params[:status].casecmp?("rejected")
            expense.update(approval_status: "Rejected")
            expense.destroy
          else
            render json: { message: 'Invalid approval status' }, status: :bad_request
            return
          end
          render json: { message: 'Expense status updated successfully' }
        else
          render json: { message: 'Expense not found' }, status: :not_found
        end
      else
        render json: { message: 'Unauthorized' }, status: :unauthorized
      end
    end

    #DELETE
    def destroy
      user = Employee.find_by(id: params[:user_id])
      Current.current_user = user
      expense_report = ExpenseReport.find(params[:expense_report_id])
      authorize expense_report, :destroy?

      expense = expense_report.expenses.find_by(id: params[:expense_id])

      if expense
        if expense.destroy
          render json: "Expense deleted successfully!"
        else
          render json: "Error deleting expense!", status: :unprocessable_entity
        end
      else
        render json: "Expense not found or unauthorized action!", status: :unprocessable_entity
      end
    end

  private
  def validate_invoice(invoice_no)
    api_key = 'b490bb80'
    url = 'https://my.api.mockaroo.com/invoices.json'
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request['X-API-Key'] = api_key
    request.body = { 'invoice_id': invoice_no }.to_json
    response = http.request(request)
    response.code == '200' && JSON.parse(response.body)["status"] == true
    rescue StandardError => e
      puts "Error validating invoice: #{e.message}"
      false
    end
  private
  def expense_params
    params.permit(:employee_id, :expense_report_id, :invoice_no, :date, :description, :amount, :approval_status)
  end

  end

