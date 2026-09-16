class CreateCoachProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :coach_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :headline
      t.text :description
      t.decimal :hourly_rate
      t.integer :years_experience
      t.boolean :verified

      t.timestamps
    end
  end
end
