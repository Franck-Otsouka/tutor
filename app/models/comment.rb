class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true
  belongs_to :coach_content, optional: true

  validates :content, presence: true

  validate :commentable_present

  private

  def commentable_present
    return if post.present? || coach_content.present?

    errors.add(:base, "Comment must belong to a post or coach content")
  end
end
