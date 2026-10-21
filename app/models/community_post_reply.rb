class CommunityPostReply < ApplicationRecord
  belongs_to :user
  belongs_to :community_post

  validates :content,
            presence: true,
            length: { maximum: 5000 }
end
