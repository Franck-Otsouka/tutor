class CreateCommunityGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :community_groups do |t|
      t.string :name
      t.text :description
      t.boolean :membership_required

      t.timestamps
    end
  end
end
