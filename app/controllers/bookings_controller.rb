class BookingsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_booking,
                only: [
                  :show,
                  :edit,
                  :update,
                  :destroy,
                  :confirm,
                  :cancel,
                  :complete
                ]

  before_action :authorize_booking_access!,
                only: [
                  :show,
                  :edit,
                  :update,
                  :destroy
                ]

  def index
    if current_user.coach?
      @bookings = Booking
        .joins(service: :coach_profile)
        .where(coach_profiles: { user_id: current_user.id })
        .includes(:student, service: :coach_profile)
        .order(start_time: :asc)
    else
      @bookings = current_user.bookings
        .includes(service: :coach_profile)
        .order(start_time: :asc)
    end
  end

  def show
  end

  def new
    @booking = Booking.new
    @booking.student = current_user

    if params[:service_id].present?
      @booking.service_id = params[:service_id]
    end

    @services = Service.where(active: true).includes(:coach_profile)
  end

    def create
    @booking = Booking.new(booking_params)
    @booking.student = current_user

    if @booking.service && @booking.start_time.present?
      @booking.end_time =
        @booking.start_time + @booking.service.duration.minutes
    end

    if @booking.save
      redirect_to @booking,
                  notice: "Booking created successfully."
    else
      @services = Service.where(active: true).includes(:coach_profile)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @services = Service.where(active: true).includes(:coach_profile)
  end

    def update
    if @booking.start_time.present? && @booking.service
      @booking.end_time =
        @booking.start_time + @booking.service.duration.minutes
    end

    if @booking.update(booking_params)
      redirect_to @booking,
                  notice: "Booking updated successfully."
    else
      @services = Service.where(active: true).includes(:coach_profile)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy

    redirect_to bookings_path,
                notice: "Booking cancelled successfully."
  end

  def confirm
    authorize_coach!

    @booking.confirmed!

    redirect_to @booking,
                notice: "Booking confirmed."
  end

  def cancel
    authorize_coach!

    @booking.cancelled!

    redirect_to @booking,
                notice: "Booking cancelled."
  end

  def complete
    authorize_coach!

    @booking.completed!

    redirect_to @booking,
                notice: "Booking marked as completed."
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def authorize_booking_access!
    return if @booking.student == current_user

    if current_user.coach? &&
       @booking.service.coach_profile&.user_id == current_user.id
      return
    end

    redirect_to bookings_path,
                alert: "You are not authorized to access this booking."
  end

  def authorize_coach!
    unless current_user.coach? &&
           @booking.service.coach_profile&.user_id == current_user.id

      redirect_to bookings_path,
                  alert: "Not authorized."

      return
    end
  end

    def booking_params
    params.require(:booking).permit(
      :service_id,
      :start_time
    )
  end
end
