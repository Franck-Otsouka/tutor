class CommunityGroupsController < ApplicationController
  def index
    @community_groups = CommunityGroup
      .includes(:group_memberships)
      .order(created_at: :desc)
  end

  def show
    @community_group = CommunityGroup.find(params[:id])

    @member_count = @community_group.group_memberships.count

    @membership =
    if user_signed_in?
      current_user.group_memberships.find_by(
        community_group: @community_group
      )
    end
  end
end
