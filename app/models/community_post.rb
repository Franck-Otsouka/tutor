class CommunityPost < ApplicationRecord
  belongs_to :user
  belongs_to :community_group

  has_one_attached :media

  has_many :community_post_replies,
           dependent: :destroy

  validates :content,
            presence: true,
            length: { maximum: 5000 }

  validates :link_url,
            length: { maximum: 2048 },
            allow_blank: true
end
