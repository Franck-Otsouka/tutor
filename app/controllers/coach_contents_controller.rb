class CoachContentsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :require_coach!, except: [:show]
  before_action :set_coach_content, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @coach_contents = current_user
      .coach_contents
      .order(created_at: :desc)
  end

  def new
    @coach_content = current_user.coach_contents.build
  end

  def show
    unless @coach_content.public_content? || can_view_members_only_content?
      redirect_to feed_path,
          alert: "This content is available to members only."
        return
    end

      @coach_content.increment!(:views_count)
  end

  def create
    @coach_content = current_user.coach_contents.build(
      coach_content_params
    )

    if @coach_content.save
      redirect_to coach_contents_path,
                  notice: "Content published successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @coach_content.update(coach_content_params)
      redirect_to coach_contents_path,
                  notice: "Content updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @coach_content.destroy

    redirect_to coach_contents_path,
                notice: "Content deleted successfully."
  end

  private

  def set_coach_content
    @coach_content = CoachContent.find(params[:id])
  end

  def authorize_owner!
    return if @coach_content.user == current_user

    redirect_to coach_contents_path,
                alert: "You are not authorized to manage this content."
  end

  def require_coach!
    return if current_user.coach?

    redirect_to root_path,
                alert: "You must be a coach to manage content."
  end

  def coach_content_params
    params.require(:coach_content).permit(
      :title,
      :content,
      :visibility,
      :content_type,
      :media
    )
  end

  def can_view_members_only_content?
    return false unless user_signed_in?

    return true if @coach_content.user == current_user

    Subscription
      .joins(:membership_plan)
      .where(
        user: current_user,
        status: "active",
        membership_plans: {
          coach_profile_id: @coach_content.user.coach_profile.id
        }
      )
      .exists?
  end
end
