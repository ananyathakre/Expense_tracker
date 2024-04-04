class ExpenseReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    @expense_report = ExpenseReport.all
    render json: { message: 'Expense reports retrieved successfully', expense_reports: @expense_reports }
  end
  def show
    user = Employee.find_by(id: params[:user_id])
    authorize user, policy_class: ExpenseReportPolicy

    @expense_reports = if policy(user).show?
                          user.admin_status ? ExpenseReport.all : user.expense_reports
                        else
                          []
                        end
    render json: @expense_reports
  end
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

  def update
    user = Employee.find_by(id: params[:user_id])
    Current.current_user = user
    expense_report = ExpenseReport.find(params[:expense_report_id])
    authorize expense_report, :update?

    if expense_report.update(expense_report_params)
      render json: expense_report
    else
      render json: { errors: expense_report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def expense_report_params
    params.permit([:title,:employee_id])
  end
 end
