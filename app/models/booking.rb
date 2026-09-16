class Booking < ApplicationRecord
  belongs_to :student, class_name: "User", inverse_of: :bookings, inverse_of: :bookings
  belongs_to :service
end
