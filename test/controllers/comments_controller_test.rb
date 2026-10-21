require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @student = users(:one)
    @coach = users(:two)
    @community_group = community_groups(:one)
    @post = posts(:one)

    @comment = Comment.create!(
      user: @student,
      post: @post,
      content: "Test comment"
    )
  end

  test "student can create a comment" do
    sign_in @student

    assert_difference("Comment.count", 1) do
      post comments_url, params: {
        comment: {
          post_id: @post.id,
          content: "A student comment"
        }
      }
    end

    created_comment = Comment.order(:created_at).last

    assert_redirected_to community_group_post_url(
      @community_group,
      @post
    )

    assert_equal @student, created_comment.user
    assert_equal @post, created_comment.post
    assert_equal "A student comment", created_comment.content
  end

  test "coach can create a comment" do
    sign_in @coach

    assert_difference("Comment.count", 1) do
      post comments_url, params: {
        comment: {
          post_id: @post.id,
          content: "A coach comment"
        }
      }
    end

    created_comment = Comment.order(:created_at).last

    assert_redirected_to community_group_post_url(
      @community_group,
      @post
    )

    assert_equal @coach, created_comment.user
    assert_equal @post, created_comment.post
  end

  test "student can update their own comment" do
    sign_in @student

    patch comment_url(@comment), params: {
      comment: {
        content: "Updated student comment"
      }
    }

    assert_redirected_to community_group_post_url(
      @community_group,
      @post
    )

    assert_equal "Updated student comment", @comment.reload.content
  end

  test "coach can update their own comment" do
    @comment.update!(user: @coach)

    sign_in @coach

    patch comment_url(@comment), params: {
      comment: {
        content: "Updated coach comment"
      }
    }

    assert_redirected_to community_group_post_url(
      @community_group,
      @post
    )

    assert_equal "Updated coach comment", @comment.reload.content
  end

  test "student cannot update another user's comment" do
    sign_in @coach

    patch comment_url(@comment), params: {
      comment: {
        content: "Unauthorized update"
      }
    }

    assert_redirected_to root_url

    assert_equal(
      "You are not authorized to manage this comment.",
      flash[:alert]
    )

    assert_equal "Test comment", @comment.reload.content
  end

  test "student can delete their own comment" do
    sign_in @student

    assert_difference("Comment.count", -1) do
      delete comment_url(@comment)
    end

    assert_redirected_to community_group_post_url(
      @community_group,
      @post
    )
  end

  test "coach can delete their own comment" do
    @comment.update!(user: @coach)

    sign_in @coach

    assert_difference("Comment.count", -1) do
      delete comment_url(@comment)
    end

    assert_redirected_to community_group_post_url(
      @community_group,
      @post
    )
  end

  test "user cannot delete another user's comment" do
    sign_in @coach

    assert_no_difference("Comment.count") do
      delete comment_url(@comment)
    end

    assert_redirected_to root_url

    assert_equal(
      "You are not authorized to manage this comment.",
      flash[:alert]
    )

    assert Comment.exists?(@comment.id)
  end
end
