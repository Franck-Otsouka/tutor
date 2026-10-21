class AddCoachProfileToMembershipPlans < ActiveRecord::Migration[8.1]
  def change
    add_reference :membership_plans,
                  :coach_profile,
                  null: true,
                  foreign_key: true
  end
end
