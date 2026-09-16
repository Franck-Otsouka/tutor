class Post < ApplicationRecord
  belongs_to :user
  belongs_to :community_group

  has_many :comments, dependent: :destroy
end
