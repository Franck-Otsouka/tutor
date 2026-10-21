class ServicesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_coach!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @categories = Category.order(:name)

  @services = Service
    .where(active: true)
    .includes(:category, coach_profile: :user)

  if params[:category_id].present?
    @services = @services.where(
      category_id: params[:category_id]
    )
  end

  if params[:query].present?
    query = "%#{params[:query]}%"

    @services = @services.where(
      "services.title ILIKE :query OR services.description ILIKE :query",
      query: query
    )
  end

    @services = @services
      .order(:title)
      .page(params[:page])
      .per(12)
  end

  def show
  end

  def new
    @coach_profile = current_user.coach_profile

    unless @coach_profile
      redirect_to new_coach_profile_path,
                  alert: "Create your coach profile before adding services."
      return
    end

    @service = @coach_profile.services.build(active: true)
    @categories = Category.order(:name)
  end

  def create
    @coach_profile = current_user.coach_profile

    unless @coach_profile
      redirect_to new_coach_profile_path,
                  alert: "Create your coach profile before adding services."
      return
    end

    @service = @coach_profile.services.build(service_params)

    if @service.save
      redirect_to @service, notice: "Service created successfully."
    else
      @categories = Category.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = Category.order(:name)
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: "Service updated successfully."
    else
      @categories = Category.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @service.destroy
      redirect_to services_path,
                 notice: "Service deleted."
    else
      redirect_to services_path,
                alert: @service.errors.full_messages.to_sentence
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def require_coach!
    return if current_user.coach?

    redirect_to root_path,
                alert: "You must be a coach to manage services."
  end

  def authorize_owner!
    return if @service.coach_profile.user == current_user

    redirect_to services_path,
                alert: "You are not authorized to manage this service."
  end

  def service_params
    params.require(:service).permit(
      :category_id,
      :title,
      :description,
      :duration,
      :price,
      :active
    )
  end
end
