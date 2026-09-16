class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :coach_profile, dependent: :destroy

  has_many :bookings, foreign_key: :student_id, inverse_of: :student, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many :group_memberships, dependent: :destroy
  has_many :community_groups, through: :group_memberships

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
