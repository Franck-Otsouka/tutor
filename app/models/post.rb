class Post < ApplicationRecord
  belongs_to :user
  belongs_to :community_group

  has_many :comments, dependent: :destroy

  validates :content,
            presence: true,
            length: { maximum: 5000 }

  validate :user_must_be_coach

  private

  def user_must_be_coach
    return if user&.coach?

    errors.add(:user, "must be a coach to create posts")
  end
end
