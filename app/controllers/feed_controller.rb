class FeedController < ApplicationController
  def index
    @contents = CoachContent
      .includes(:user)
      .public_content
      .order(created_at: :desc)

    @online_users = User
      .where.not(id: current_user.id)
      .order(created_at: :desc)
      .limit(8)
  end
end
