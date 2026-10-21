class AddUniqueIndexToGroupMemberships < ActiveRecord::Migration[8.1]
  def change
    add_index :group_memberships,
              [:user_id, :community_group_id],
              unique: true,
              name: "index_group_memberships_on_user_and_community"
  end
end
