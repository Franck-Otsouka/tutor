class CoachDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_coach!

  def show
    @coach_profile = current_user.coach_profile

    @bookings = Booking
      .joins(service: :coach_profile)
      .where(coach_profiles: { user_id: current_user.id })
      .includes(:student, service: :category)
      .order(start_time: :asc)

    @pending_bookings = @bookings.select(&:pending?)

    @upcoming_bookings = @bookings.select do |booking|
      booking.confirmed? &&
        booking.start_time.present? &&
        booking.start_time >= Time.current
    end

    @completed_bookings = @bookings.select(&:completed?)

    @services = @coach_profile
      &.services
      &.includes(:category)
      &.order(created_at: :desc) || []

    @community_groups = CommunityGroup
      .order(created_at: :desc)

    @recent_posts = Post
      .where(user: current_user)
      .includes(:community_group)
      .order(created_at: :desc)
      .limit(5)

    @coach_contents = current_user
      .coach_contents
      .order(created_at: :desc)
      .limit(5)
  end

  private

  def require_coach!
    return if current_user.coach?

    redirect_to root_path,
                alert: "You must be a coach to access the dashboard."
  end
end
