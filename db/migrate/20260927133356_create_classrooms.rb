class CreateClassrooms < ActiveRecord::Migration[8.1]
  def change
    create_table :classrooms do |t|
      t.references :representative,
                   null: false,
                   foreign_key: { to_table: :users }

      t.string :name
      t.text :description
      t.boolean :private, default: true

      t.timestamps
    end
  end
end
