class MakeCoachProfileRequiredOnMembershipPlans < ActiveRecord::Migration[8.1]
  def change
    change_column_null :membership_plans, :coach_profile_id, false
  end
end
