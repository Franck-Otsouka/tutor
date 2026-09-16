class CreateGroupMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :group_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :community_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
