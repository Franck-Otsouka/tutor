class Service < ApplicationRecord
  belongs_to :coach_profile
  belongs_to :category

  has_many :bookings, dependent: :restrict_with_error

  validates :title,
            presence: true,
            length: { maximum: 100 }

  validates :description,
            presence: true,
            length: { maximum: 2000 }

  validates :duration,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }

  validates :price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }
end
