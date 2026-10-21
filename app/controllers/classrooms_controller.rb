class ClassroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_classroom, only: [:show, :edit, :update, :destroy]
  before_action :require_student!
  before_action :authorize_representative!,
                only: [:edit, :update, :destroy]

  def index
    @classrooms = current_user.classrooms
  end

  def show
  end

  def new
    @classroom = Classroom.new
  end

  def create
    @classroom = Classroom.new(classroom_params)
    @classroom.representative = current_user

    if @classroom.save
      ClassroomMembership.create!(
        user: current_user,
        classroom: @classroom
      )

      redirect_to @classroom,
                  notice: "Classroom created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @classroom.update(classroom_params)
      redirect_to @classroom,
                  notice: "Classroom updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @classroom.destroy

    redirect_to classrooms_path,
                notice: "Classroom deleted successfully."
  end

  private

  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  def classroom_params
    params.require(:classroom).permit(
      :name,
      :description,
      :private
    )
  end

  def require_student!
    return if current_user.student?

    redirect_to root_path,
                alert: "Only students can manage classrooms."
  end

  def authorize_representative!
    return if @classroom.representative == current_user

    redirect_to @classroom,
                alert: "Only the Class Representative can manage this classroom."
  end
end
