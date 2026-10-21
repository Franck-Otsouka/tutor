require "test_helper"

class CoachContentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @coach = users(:two)
    sign_in @coach
    @coach_content = coach_contents(:one)
  end

  test "should get index" do
    get coach_contents_path

    assert_response :success
  end

  test "should get new" do
    get new_coach_content_path

    assert_response :success
  end

  test "should create coach content" do
    assert_difference("CoachContent.count", 1) do
      post coach_contents_path, params: {
        coach_content: {
          title: "Test Content",
          content: "This is test content.",
          visibility: "public_content",
          content_type: "post"
        }
      }
    end

    assert_redirected_to coach_contents_path
  end

  test "should show coach content" do
    get coach_content_path(@coach_content)

    assert_response :success
  end

  test "should get edit" do
    get edit_coach_content_path(@coach_content)

    assert_response :success
  end

  test "should update coach content" do
    patch coach_content_path(@coach_content), params: {
      coach_content: {
        title: "Updated Content"
      }
    }

    assert_redirected_to coach_contents_path
    assert_equal "Updated Content", @coach_content.reload.title
  end

  test "should destroy coach content" do
    assert_difference("CoachContent.count", -1) do
      delete coach_content_path(@coach_content)
    end

    assert_redirected_to coach_contents_path
  end
end
