class HomeController < ApplicationController
  def index
    @coach_profiles = CoachProfile
      .includes(:user)
      .where(verified: true)
      .order(created_at: :desc)
      .limit(6)

    @categories = Category.order(:name)

    @featured_video = CoachContent
      .includes(:user)
      .where(content_type: "video")
      .order(created_at: :desc)
      .first
  end
end
