class EmployeePolicy < ApplicationPolicy
	def show?
		user&.admin_status || user&.id == record&.id
	end
	def destroy?
		user.admin_status?
	end

end
