class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :coach_profile, null: false, foreign_key: true
      t.integer :rating
      t.text :comment

      t.index [:user_id, :coach_profile_id], unique: true

      t.timestamps
    end
  end
end
