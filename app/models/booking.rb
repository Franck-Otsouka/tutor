class Booking < ApplicationRecord
  belongs_to :student,
             class_name: "User",
             inverse_of: :bookings

  belongs_to :service

  enum :status, {
    pending: "pending",
    confirmed: "confirmed",
    cancelled: "cancelled",
    completed: "completed"
  }

  after_initialize :set_default_status, if: :new_record?

  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :end_time_after_start_time
  validate :start_time_cannot_be_in_the_past
  validate :coach_is_available
  private

  def set_default_status
    self.status ||= "pending"
  end

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end

  def start_time_cannot_be_in_the_past
    return if start_time.blank?

    if start_time < Time.current
      errors.add(:start_time, "cannot be in the past")
    end
  end
  def coach_is_available
  return if start_time.blank? || end_time.blank? || service.blank?

  coach_profile = service.coach_profile
  return if coach_profile.blank?

  overlapping_booking = Booking
    .joins(:service)
    .where(services: { coach_profile_id: coach_profile.id })
    .where.not(id: id)
    .where.not(status: "cancelled")
    .where(
      "start_time < ? AND end_time > ?",
      end_time,
      start_time
    )
    .exists?

  if overlapping_booking
    errors.add(:start_time, "is not available for this coach")
  end
end
end
