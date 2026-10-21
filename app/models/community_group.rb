class CommunityGroup < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships

  has_many :posts, dependent: :destroy
  has_many :community_posts, dependent: :destroy
end
