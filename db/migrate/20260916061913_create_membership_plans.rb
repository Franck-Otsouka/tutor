class CreateMembershipPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :membership_plans do |t|
      t.string :name
      t.decimal :monthly_price
      t.text :description

      t.timestamps
    end
  end
end
