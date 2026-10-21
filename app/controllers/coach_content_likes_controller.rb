class CoachContentLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coach_content

  def create
    @coach_content.likes.find_or_create_by(user: current_user)

    redirect_back fallback_location: feed_path
  end

  def destroy
    @coach_content.likes
      .find_by(user: current_user)
      &.destroy

    redirect_back fallback_location: feed_path
  end

  private

  def set_coach_content
    @coach_content = CoachContent.find(params[:coach_content_id])
  end
end
