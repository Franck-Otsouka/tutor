class GroupMembershipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @community_group = CommunityGroup.find(params[:community_group_id])

    membership = current_user.group_memberships.find_or_initialize_by(
      community_group: @community_group
    )

    if membership.save
      redirect_to community_group_path(@community_group),
                  notice: "You joined #{@community_group.name}."
    else
      redirect_to community_group_path(@community_group),
                  alert: "Unable to join this community."
    end
  end

  def destroy
    @community_group = CommunityGroup.find(params[:community_group_id])

    membership = current_user.group_memberships.find_by(
      community_group: @community_group
    )

    membership&.destroy

    redirect_to community_group_path(@community_group),
                notice: "You left #{@community_group.name}."
  end
end
