class HomeController < ApplicationController
  def index
    @coach_profiles = CoachProfile
      .includes(:user)
      .where(verified: true)
      .order(created_at: :desc)
      .limit(6)

    @categories = Category.order(:name)
  end
end
