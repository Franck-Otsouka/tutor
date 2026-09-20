require "test_helper"

class StudentProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @student_profile = student_profiles(:one)
  end

  test "should get show" do
    get student_profile_url(@student_profile)

    assert_response :success
  end

  test "should get edit" do
    get edit_student_profile_url(@student_profile)

    assert_response :success
  end

  test "should update student profile" do
    patch student_profile_url(@student_profile),
          params: {
            student_profile: {
              bio: "Updated bio",
              learning_goals: "Learn Ruby on Rails"
            }
          }

    assert_response :success
  end
end
