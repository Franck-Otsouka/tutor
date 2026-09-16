class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :role
      t.text :bio

      t.timestamps
    end
    add_index :users, :email
  end
end
