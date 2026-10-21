class CommunityPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community_group
  before_action :require_membership!
  before_action :set_community_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
  @community_posts = @community_group.community_posts
    .includes(
      :user,  
      community_post_replies: :user
    )
    .order(created_at: :desc)
  end

  def show
  end

  def new
    @community_post = @community_group.community_posts.build
  end

  def create
    @community_post = @community_group.community_posts.build(
      community_post_params
    )

    @community_post.user = current_user

    if @community_post.save
      redirect_to community_group_community_posts_path(@community_group),
                  notice: "Post published successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_reply
    @community_post = @community_group.community_posts.find(
      params[:community_post_id]
    )

    reply = @community_post.community_post_replies.build(
      reply_params
    )

    reply.user = current_user

    if reply.save
      redirect_to community_group_community_posts_path(@community_group),
                  notice: "Reply added successfully."
    else
      redirect_to community_group_community_posts_path(@community_group),
                  alert: reply.errors.full_messages.to_sentence
    end
  end

  def edit
  end

  def update
    if @community_post.update(community_post_params)
      redirect_to community_group_community_posts_path(@community_group),
                  notice: "Post updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @community_post.destroy

    redirect_to community_group_community_posts_path(@community_group),
                notice: "Post deleted successfully."
  end

  private

  def set_community_group
    @community_group = CommunityGroup.find(
      params[:community_group_id]
    )
  end

  def set_community_post
    @community_post = @community_group.community_posts.find(params[:id])
  end

  def require_membership!
    return if current_user.group_memberships.exists?(
      community_group: @community_group
    )

    redirect_to community_group_path(@community_group),
                alert: "You must join this community first."
  end

  def authorize_owner!
    return if @community_post.user == current_user

    redirect_to community_group_community_posts_path(@community_group),
                alert: "You are not authorized to manage this post."
  end

  def community_post_params
    params.require(:community_post).permit(
      :content,
      :link_url,
      :media
    )
  end
  def reply_params
    params.require(:community_post_reply).permit(:content)
  end
end
