class CommentsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    user = Employee.find_by(id: params[:user_id])
    Current.current_user = user
    authorize user, policy_class: CommentPolicy
    employee = Employee.find_by(id: params[:employee_id])
    if user.id == employee.id
      render json: "Same user can't create the first comment for their own expense"
    else
      expense = Expense.find_by(id: params[:expense_id])
      @comment = expense.comments.new(comment_params)
      if @comment.save
        render json: { message: 'Comment created successfully', comment: @comment.attributes.except("created_at", "updated_at") }
      else
        render json: { error: 'Failed to create comment' }, status: :unprocessable_entity
      end
    end
  end

  def delete
    employee = Employee.find_by(id: params[:employee_id])
    expense = Expense.find_by(id: params[:expense_id])
    comment = expense.comments.find_by(id: params[:comment_id])
    authorize comment, :destroy?
    if comment.destroy
      render json: "Comment deleted"
    else
      render json: "Not able to delete comment"
    end
  end
  private
  def comment_params
    params.permit(:content)
  end
end
