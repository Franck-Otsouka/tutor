class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community_group
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :require_coach!, only: [:new, :create, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @posts = @community_group.posts
      .includes(:user)
      .order(created_at: :desc)
  end

  def show
    @comments = @post.comments
      .includes(:user)
      .order(created_at: :asc)
  end

  def new
    @post = @community_group.posts.build
  end

  def create
    @post = @community_group.posts.build(post_params)
    @post.user = current_user

    if @post.save
      redirect_to community_group_post_path(@community_group, @post),
                  notice: "Post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to community_group_post_path(@community_group, @post),
                  notice: "Post updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy

    redirect_to community_group_posts_path(@community_group),
                notice: "Post deleted successfully."
  end

  private

  def set_community_group
    @community_group = CommunityGroup.find(params[:community_group_id])
  end

  def set_post
    @post = @community_group.posts.find(params[:id])
  end

  def require_coach!
    return if current_user.coach?

    redirect_to community_group_posts_path(@community_group),
                alert: "Only coaches can manage posts."
  end

  def authorize_owner!
    return if @post.user == current_user

    redirect_to community_group_post_path(@community_group, @post),
                alert: "You are not authorized to manage this post."
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
