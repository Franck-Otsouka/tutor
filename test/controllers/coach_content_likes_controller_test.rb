require "test_helper"

class CoachContentLikesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get coach_content_likes_create_url
    assert_response :success
  end

  test "should get destroy" do
    get coach_content_likes_destroy_url
    assert_response :success
  end
end
