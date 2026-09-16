class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.references :coach_profile, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :duration
      t.decimal :price
      t.boolean :active

      t.timestamps
    end
  end
end
