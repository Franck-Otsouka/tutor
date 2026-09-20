class SetDefaultBookingStatus < ActiveRecord::Migration[8.1]
  def change
    change_column_default :bookings, :status, from: nil, to: "pending"
  end
end
