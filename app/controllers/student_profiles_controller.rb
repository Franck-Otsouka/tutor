class StudentProfilesController < ApplicationController
  before_action :set_student_profile, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
  end

  private

  def set_student_profile
    @student_profile = StudentProfile.find(params[:id])
  end
end
