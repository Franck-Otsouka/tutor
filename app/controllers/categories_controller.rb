class CategoriesController < ApplicationController
  before_action :set_category, only: :show

  def index
    @categories = Category
      .includes(:services)
      .order(:name)
  end

  def show
    @services = @category.services
      .where(active: true)
      .includes(coach_profile: :user)
      .order(:title)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
