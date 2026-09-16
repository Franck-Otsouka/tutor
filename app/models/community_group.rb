class CommunityGroup < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :users, through: :group_memberships

  has_many :posts, dependent: :destroy
end
