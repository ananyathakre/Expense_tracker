class EmployeesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
      @employees = Employee.all
      #render json: @employees
    end
    #SHOW
    def show
      user = Employee.find_by(id: params[:user_id])
      Current.current_user = user
      if user.nil?
        render json: { message: 'No employee found with the given ID' }, status: :not_found
      else
        authorize user
        if policy(user).show?
            if user.admin_status
                employees = Employee.all.includes(expense_reports: { expenses: { comments: :replies } })
                render json: employees.as_json(include: { expense_reports: { include: { expenses: { include: { comments: { include: :replies } } } } } })
              else
                render json: user.as_json(include: { expense_reports: { include: { expenses: { include: { comments: { include: :replies } } } } } })
              end
        else
          render json: { message: 'Unauthorized' }, status: :unauthorized
        end
      end
    end

    #CREATE
    def create
        employee = Employee.new(employee_params)
        if employee.valid?
          employee.save!
          render json: employee
        else
          render json: { message: 'Employee not found with id' }, status: :unprocessable_entity
        end
    end

    #UPDATE
    def update
        employee = Employee.find_by(id: params[:employee_id])
        if employee
          if employee.update(employee_params)
            render json: employee
          else
            render json: { message: 'Failed to update employee', errors: employee.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { message: 'Employee not found' }, status: :not_found
        end
      end

    #DELETE
    def destroy
      user = Employee.find_by(id: params[:user_id])
      Current.current_user = user
      authorize user
      employee = Employee.find_by(id: params[:employee_id])
      if user && employee
        if user.id == employee.id
          render json: 'Cannot delete yourself', status: :unprocessable_entity
        else
          if employee.destroy
            render json: 'Deletion done!'
          else
            render json: 'Error deleting employee', status: :unprocessable_entity
          end
        end
      else
        render json: 'Employee not present', status: :not_found
      end
    end

    private
    def employee_params
      params.require(:employee).permit(:name, :email, :department, :admin_status, :emp_status)
    end
  end

