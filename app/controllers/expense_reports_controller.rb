class ExpenseReportsController < ApplicationController

  skip_before_action :verify_authenticity_token
  def index
      @expense_report = ExpenseReport.all
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
# def update
#   user = Employee.find_by(id: params[:user_id])
#   Current.current_user = user

#   begin
#     expense_report = ExpenseReport.find(params[:expense_report_id])
#     authorize expense_report, :update?

#     if expense_report.update(expense_report_params)
#       render json: expense_report
#     else
#       render json: { errors: expense_report.errors.full_messages }, status: :unprocessable_entity
#     end
#   rescue Pundit::NotAuthorizedError => e
#     render json: { message: 'Not authorized to update this expense report' }, status: :unauthorized
#   rescue ActiveRecord::RecordNotFound => e
#     render json: { message: 'Expense report not found' }, status: :not_found
#   rescue StandardError => e
#     render json: { message: e.message }, status: :internal_server_error
#   end
# end
def update
  user = Employee.find_by(id: params[:user_id])
  Current.current_user = user
  authorize user, policy_class: ExpenseReportPolicy

  if user.admin_status
    @expense_report = ExpenseReport.find(params[:expense_report_id])
    if params[:status].casecmp?("approved")
      if @expense_report.expenses.all? { |exp| exp.approval_status == 'Approved' }
        applied_amount = @expense_report.expenses.sum(:amount)
        approved_amount = if applied_amount < 7000
                            applied_amount
                          elsif applied_amount >= 7000 && applied_amount < 10000
                            7000
                          else
                            0
                          end
        @expense_report.update(report_status: 'Approved')
        ExpenseReportMailer.notify_approval(@expense_report.employee, @expense_report, applied_amount, approved_amount).deliver_now
      else
        render json: { message: 'All expenses in the report are not approved.' }
        return
      end
    elsif params[:status].casecmp?("rejected")
      @expense_report.update(report_status: 'Rejected')
      ExpenseReportMailer.notify_approval(@expense_report.employee, @expense_report, applied_amount, approved_amount).deliver_now
    else
      render json: { message: 'Invalid approval status' }, status: :bad_request
      return
    end
    render json: { message: 'Expense report status updated successfully' }
  else
    render json: { message: 'Unauthorized' }, status: :unauthorized
  end
end


private
def expense_report_params
  params.permit([:title,:employee_id,:report_status])
end
end
