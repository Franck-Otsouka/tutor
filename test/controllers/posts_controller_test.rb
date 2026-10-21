require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @student = users(:one)
    @coach = users(:two)
    @community_group = community_groups(:one)
    @post = posts(:one)
  end

  test "student can view community posts" do
    sign_in @student

    get community_group_posts_url(@community_group)

    assert_response :success
  end

  test "coach can view community posts" do
    sign_in @coach

    get community_group_posts_url(@community_group)

    assert_response :success
  end

  test "coach can access new post form" do
    sign_in @coach

    get new_community_group_post_url(@community_group)

    assert_response :success
  end

  test "student cannot access new post form" do
    sign_in @student

    get new_community_group_post_url(@community_group)

    assert_redirected_to community_group_posts_url(@community_group)
    assert_equal "Only coaches can manage posts.", flash[:alert]
  end

  test "coach can create a post" do
    sign_in @coach

    assert_difference("Post.count", 1) do
      post community_group_posts_url(@community_group), params: {
        post: {
          content: "A new coaching post"
        }
      }
    end

    created_post = Post.order(:created_at).last

    assert_redirected_to community_group_post_url(
      @community_group,
      created_post
    )

    assert_equal @coach, created_post.user
    assert_equal @community_group, created_post.community_group
  end

  test "student cannot create a post" do
    sign_in @student

    assert_no_difference("Post.count") do
      post community_group_posts_url(@community_group), params: {
        post: {
          content: "Student should not be able to post"
        }
      }
    end

    assert_redirected_to community_group_posts_url(@community_group)
    assert_equal "Only coaches can manage posts.", flash[:alert]
  end

  test "coach can edit their own post" do
    sign_in @coach

    get edit_community_group_post_url(
      @community_group,
      @post
    )

    assert_response :success
  end

  test "coach can update their own post" do
    sign_in @coach

    patch community_group_post_url(
      @community_group,
      @post
    ), params: {
      post: {
        content: "Updated coach post"
      }
    }

    assert_redirected_to community_group_post_url(
      @community_group,
      @post
    )

    assert_equal "Updated coach post", @post.reload.content
  end

  test "coach can delete their own post" do
    sign_in @coach

    assert_difference("Post.count", -1) do
      delete community_group_post_url(
        @community_group,
        @post
      )
    end

    assert_redirected_to community_group_posts_url(@community_group)
  end
end
