class CreateClassroomMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :classroom_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :classroom, null: false, foreign_key: true

      t.timestamps
    end

    add_index :classroom_memberships,
              [:user_id, :classroom_id],
              unique: true
  end
end
