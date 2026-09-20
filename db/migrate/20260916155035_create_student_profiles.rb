class CreateStudentProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :student_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.text :bio
      t.text :learning_goals

      t.timestamps
    end
  end
end
