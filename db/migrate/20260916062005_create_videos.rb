class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.references :coach_profile, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :visibility
      t.boolean :published

      t.timestamps
    end
  end
end
