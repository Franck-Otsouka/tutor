class MembershipPlan < ApplicationRecord
  belongs_to :coach_profile
  has_many :subscriptions, dependent: :restrict_with_error
end
