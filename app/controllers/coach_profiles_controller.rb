
class CoachProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_coach_profile, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]
  before_action :authorize_coach_creation!, only: [:new, :create]

  def index
    @coach_profiles = CoachProfile
      .includes(:user)
      .order(created_at: :desc)
  end

  def show
    @services = @coach_profile.services
      .where(active: true)
      .includes(:category)
      .order(:title)

    @coach_contents = @coach_profile.user.coach_contents
      .order(created_at: :desc)

    @member =
      current_user.present? &&
      current_user.subscriptions
        .joins(:membership_plan)
        .where(
          membership_plans: {
            coach_profile_id: @coach_profile.id
          }
         )
        .where(status: "active")
        .exists?
  end

  def new
    @coach_profile = current_user.build_coach_profile
  end

  def create
    @coach_profile = current_user.build_coach_profile(coach_profile_params)

    if @coach_profile.save
      current_user.update!(role: :coach) unless current_user.coach?

      redirect_to @coach_profile,
                  notice: "Coach profile created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    user_updated = @coach_profile.user.update(user_params)
    profile_updated = @coach_profile.update(coach_profile_params)

    if user_updated && profile_updated
      redirect_to @coach_profile,
                  notice: "Coach profile updated successfully."
    else
      # Reload the profile so the form displays the submitted values
      @coach_profile.assign_attributes(coach_profile_params)

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @coach_profile.destroy

    redirect_to coach_profiles_path,
                notice: "Coach profile deleted."
  end

  private

  def set_coach_profile
    @coach_profile = CoachProfile.find(params[:id])
  end

  def authorize_owner!
    return if @coach_profile.user == current_user

    redirect_to coach_profiles_path,
                alert: "You are not authorized to manage this profile."
  end

  def authorize_coach_creation!
    return if current_user.student? && !current_user.coach_profile.present?

    redirect_to root_path,
                alert: "You already have a coach profile."
  end

  def coach_profile_params
    params.require(:coach_profile).permit(
      :headline,
      :description,
      :hourly_rate,
      :years_experience
    )
  end

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :avatar
    )
  end
end
