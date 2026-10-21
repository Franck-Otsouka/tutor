class CoachContentLike < ApplicationRecord
  belongs_to :user
  belongs_to :coach_content

  validates :user_id,
            uniqueness: {
              scope: :coach_content_id
            }
end
