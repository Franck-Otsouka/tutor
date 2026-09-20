class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coach_profile
  before_action :require_student!, only: [:create]
  before_action :set_review, only: [:destroy]
  before_action :authorize_review_owner!, only: [:destroy]

  def create
    unless completed_booking_with_coach?
      redirect_to @coach_profile,
                  alert: "You can only review a coach after completing a booking."
      return
    end

    @review = @coach_profile.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @coach_profile,
                  notice: "Your review was added successfully."
    else
      redirect_to @coach_profile,
                  alert: @review.errors.full_messages.to_sentence
    end
  end

  def destroy
    @review.destroy

    redirect_to @coach_profile,
                notice: "Your review was deleted."
  end

  private

  def set_coach_profile
    @coach_profile = CoachProfile.find(params[:coach_profile_id])
  end

  def set_review
    @review = @coach_profile.reviews.find(params[:id])
  end

  def require_student!
    return if current_user.student?

    redirect_to @coach_profile,
                alert: "Only students can leave reviews."
  end

  def authorize_review_owner!
    return if @review.user == current_user

    redirect_to @coach_profile,
                alert: "You are not authorized to delete this review."
  end

  def completed_booking_with_coach?
    Booking
      .joins(service: :coach_profile)
      .where(
        student: current_user,
        coach_profiles: { id: @coach_profile.id },
        status: "completed"
      )
      .exists?
  end

  def review_params
    params.require(:review).permit(
      :rating,
      :comment
    )
  end
end
