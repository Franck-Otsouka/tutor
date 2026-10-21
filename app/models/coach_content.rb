class CoachContent < ApplicationRecord
  belongs_to :user

  has_one_attached :media
  has_many :comments, dependent: :destroy
  has_many :likes,
         class_name: "CoachContentLike",
         dependent: :destroy

  enum :visibility, {
    public_content: 0,
    members_only: 1
  }

  enum :content_type, {
    post: 0,
    photo: 1,
    video: 2
  }

  validates :title, presence: true
  validates :visibility, presence: true
  validates :content_type, presence: true

  validate :user_must_be_coach

  private

  def user_must_be_coach
    return if user&.coach?

    errors.add(:user, "must be a coach")
  end
end
