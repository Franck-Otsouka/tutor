class Review < ApplicationRecord
  belongs_to :user
  belongs_to :coach_profile

  validates :rating,
            presence: true,
            inclusion: { in: 1..5 }

  validates :comment,
            length: { maximum: 1000 },
            allow_blank: true

  validates :user_id,
            uniqueness: {
              scope: :coach_profile_id,
              message: "has already reviewed this coach"
            }
end
