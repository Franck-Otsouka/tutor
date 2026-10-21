class CreateCommunityPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :community_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :community_group, null: false, foreign_key: true
      t.text :content
      t.string :link_url

      t.timestamps
    end
  end
end
