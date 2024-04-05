class ExpenseReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @expense_report = ExpenseReport.all
    #render json: { message: 'Expense reports retrieved successfully', expense_reports: @expense_reports }
  end

  #SHOW
  def show
    begin
      user = Employee.find_by(id: params[:user_id])
      authorize user, policy_class: ExpenseReportPolicy

      @expense_reports = if policy(user).show?
                            user.admin_status ? ExpenseReport.all : user.expense_reports
                          else
                            []
                          end
      render json: @expense_reports
    rescue Pundit::NotDefinedError => e
      render json: { message: 'Non identified employee' }, status: :internal_server_error
    end
  end

  #CREATE
  def create
    employee = Employee.find_by(id: params[:employee_id])

    if employee && employee.emp_status == 'active'
      expense_report = employee.expense_reports.new(expense_report_params)

      if expense_report.save
        render json: expense_report
      else
        render json: { details: expense_report.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Invalid employee or inactive employee' }, status: :unprocessable_entity
    end
  end

  #DELETE
  def destroy
    user = Employee.find_by(id: params[:user_id])
    Current.current_user = user
    expense_report = ExpenseReport.find(params[:expense_report_id])
    authorize expense_report, :destroy?

    if expense_report.destroy
      render json: "Expense report deleted successfully!"
    else
      render json: "Error deleting expense report!", status: :unprocessable_entity
    end
  end

  #UPDATE
  def update
    user = Employee.find_by(id: params[:user_id])
    Current.current_user = user

    begin
      expense_report = ExpenseReport.find(params[:expense_report_id])
      authorize expense_report, :update?

      if expense_report.update(expense_report_params)
        render json: expense_report
      else
        render json: { errors: expense_report.errors.full_messages }, status: :unprocessable_entity
      end
    rescue Pundit::NotAuthorizedError => e
      render json: { message: 'Not authorized to update this expense report' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: 'Expense report not found' }, status: :not_found
    rescue StandardError => e
      render json: { message: e.message }, status: :internal_server_error
    end
  end

  private
  def expense_report_params
    params.permit([:title,:employee_id])
  end
 end
