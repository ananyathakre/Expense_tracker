class ExpenseReportPolicy < ApplicationPolicy
	def show?
		user&.admin_status || (user&.id == record&.employee_id)
	  end
	  def update?
		user.admin_status?
	  end
	  def destroy?
		user&.id == record&.employee_id
	  end
end