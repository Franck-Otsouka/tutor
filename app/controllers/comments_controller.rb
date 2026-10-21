class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:update, :destroy]
  before_action :authorize_owner!, only: [:update, :destroy]

  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      redirect_after_comment(
        @comment,
        notice: "Comment added successfully."
      )
    else
      redirect_after_comment(
        @comment,
        alert: @comment.errors.full_messages.to_sentence
      )
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_after_comment(
        @comment,
        notice: "Comment updated successfully."
      )
    else
      redirect_after_comment(
        @comment,
        alert: @comment.errors.full_messages.to_sentence
      )
    end
  end

  def destroy
    commentable = @comment.post || @comment.coach_content

    @comment.destroy

    redirect_after_comment(
      @comment,
      notice: "Comment deleted successfully."
    )
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_owner!
    return if @comment.user == current_user

    redirect_to root_path,
                alert: "You are not authorized to manage this comment."
  end

  def comment_params
    params.require(:comment).permit(
      :post_id,
      :coach_content_id,
      :content
    )
  end

  def redirect_after_comment(comment, notice: nil, alert: nil)
    if comment.post.present?
      redirect_to community_group_post_path(
        comment.post.community_group,
        comment.post
      ), notice: notice, alert: alert
    elsif comment.coach_content.present?
      redirect_to feed_path,
                  notice: notice,
                  alert: alert
    else
      redirect_to feed_path,
                  notice: notice,
                  alert: alert
    end
  end
end
