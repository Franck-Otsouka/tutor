class CoachProfile < ApplicationRecord
  belongs_to :user

  has_many :services, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :streams, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :membership_plans, dependent: :destroy

  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end

  def reviews_count
    reviews.count
  end
end
