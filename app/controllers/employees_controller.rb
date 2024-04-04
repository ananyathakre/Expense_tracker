class EmployeesController < ApplicationController
    skip_before_action :verify_authenticity_token
	def index
		@employee = Employee.all
		#render json: @employee	#not able to achieve filtering for this
	end
	def show
		user = Employee.find_by(id: params[:user_id])
		Current.current_user = user
		authorize user
		if policy(user).show?
			if user.admin_status
				@employees = Employee.all
				render json: @employees
			else
				render json: { message: 'Employee details retrieved successfully', employee: user }
			end
		else
			render json: { message: 'Unauthorized' }, status: :unauthorized
		end
	end

   def update
		employee = Employee.find_by(id: params[:employee_id])
		employee.update(emp_status: "terminated")
		render json: employee
	end

	def create
		employee = Employee.new(employee_params(params))
        Rails.logger.info "#{employee_params(params)}"
		email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
		email_to_check = employee.email
		if email_to_check =~ email_regex
			if employee.valid?
				employee.save!
				render json: employee
			else
				render json: { details: employee.errors.full_messages }
			end
		else
			render json: "Email pattern is incorrect!"
		end
	end

	def destroy
		user = Employee.find_by(id: params[:user_id])
		Current.current_user = user
        authorize user
		employee = Employee.find_by(id: params[:employee_id])
		if user && employee
		  if user.id == employee.id
			render json: "Error"
		  else
			if employee.destroy
			  render json: "Deletion done!"
			else
			  render json: "Error!"
			end
		  end
		else
		  render json: "User or employee not present!"
		end
	end

	private
	def employee_params(params)
		params.permit(%w[name email department admin_status emp_status])
	end
end
