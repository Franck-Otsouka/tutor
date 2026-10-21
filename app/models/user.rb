class User < ApplicationRecord
  enum :role, {
    student: 0,
    coach: 1,
    admin: 2
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_one :coach_profile, dependent: :destroy
  has_one :student_profile, dependent: :destroy

  has_many :coach_content_likes, dependent: :destroy

  has_many :bookings,
           foreign_key: :student_id,
           inverse_of: :student,
           dependent: :destroy

  has_many :subscriptions, dependent: :destroy

  has_many :group_memberships, dependent: :destroy
  has_many :community_groups, through: :group_memberships

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :coach_contents, dependent: :destroy
  has_many :community_posts, dependent: :destroy

  has_many :represented_classrooms,
         class_name: "Classroom",
         foreign_key: :representative_id,
         dependent: :destroy

  has_many :classroom_memberships,
         dependent: :destroy

  has_many :classrooms,
         through: :classroom_memberships

    # Classroom Representative
  has_many :represented_classrooms,
           class_name: "Classroom",
           foreign_key: :representative_id,
           dependent: :destroy

    # Classroom Memberships
  has_many :classroom_memberships,
           dependent: :destroy

  has_many :classrooms,
           through: :classroom_memberships

  accepts_nested_attributes_for :coach_profile
end
