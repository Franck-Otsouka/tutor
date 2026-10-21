class Classroom < ApplicationRecord
  belongs_to :representative,
             class_name: "User"

  has_many :classroom_memberships,
           dependent: :destroy

  has_many :users,
           through: :classroom_memberships

  validates :name, presence: true
end
