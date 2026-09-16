class CoachProfile < ApplicationRecord
  belongs_to :user

  has_many :services, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :streams, dependent: :destroy
end
