class ExpensePolicy < ApplicationPolicy
  def update?
		user.admin_status?
	end
	def show?
		user&.admin_status || user&.id == record&.expense_report&.employee_id
	end
	def destroy?
		user&.id == record&.expense_report&.employee_id
	  end
end
