class Service < ApplicationRecord
  belongs_to :coach_profile
  belongs_to :category

  has_many :bookings, dependent: :restrict_with_error
end
