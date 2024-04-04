class CommentPolicy < ApplicationPolicy
	def create?
		user.admin_status?
	end
	def destroy?
		user == record.user
	end
end