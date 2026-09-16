class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :membership_plan
end
