class RepliesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
      comment = Comment.find_by(id: params[:comment_id])
      reply = Reply.new(reply_params)
      if reply.save!
          render json: "Reply comment is added"
      else
          render json: "Failure in adding reply comment"
      end
  end

  def delete
      comment = Comment.find_by(id: params[:comment_id])
      reply = comment.replies.find_by(id: params[:reply_id])
      if reply.destroy!
          render json: "Reply comment is deleted"
      else
          render json: "Failure in deleting the reply comment"
      end
  end

  private
  def reply_params
      params.permit(:comment_id, :content)
  end
end