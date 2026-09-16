class CreateStreams < ActiveRecord::Migration[7.1]
  def change
    create_table :streams do |t|
      t.references :coach_profile, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :scheduled_at
      t.integer :visibility

      t.timestamps
    end
  end
end
