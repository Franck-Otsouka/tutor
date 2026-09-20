require "test_helper"

class CoachDashboardControllerTest < ActionDispatch::IntegrationTest
  test "requires authentication" do
    get coach_dashboard_path

    assert_response :redirect
  end
end
