class CreateCoachContentLikes < ActiveRecord::Migration[8.1]
  def change
    create_table :coach_content_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :coach_content, null: false, foreign_key: true

      t.timestamps
    end

    add_index :coach_content_likes,
              [:user_id, :coach_content_id],
              unique: true
  end
end
