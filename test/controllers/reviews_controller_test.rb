require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @student = users(:one)
    @coach = users(:two)
    @coach_profile = coach_profiles(:two)
    @completed_booking = bookings(:one)
  end

  test "student with completed booking can create review" do
    sign_in @student

    assert_difference("Review.count", 1) do
      post coach_profile_reviews_url(@coach_profile),
           params: {
             review: {
               rating: 5,
               comment: "Excellent coaching session."
             }
           }
    end

    assert_redirected_to coach_profile_url(@coach_profile)

    review = Review.order(:created_at).last

    assert_equal @student, review.user
    assert_equal @coach_profile, review.coach_profile
    assert_equal 5, review.rating
  end

  test "student without completed booking cannot create review" do
  sign_in @student

  Booking.where(id: @completed_booking.id).update_all(status: "pending")

  assert_no_difference("Review.count") do
      post coach_profile_reviews_url(@coach_profile),
           params: {
             review: {
               rating: 5,
               comment: "Should not be allowed."
             }
           }
    end

    assert_redirected_to coach_profile_url(@coach_profile)
  end

  test "student cannot review the same coach twice" do
    sign_in @student

    Review.create!(
      user: @student,
      coach_profile: @coach_profile,
      rating: 4,
      comment: "First review."
    )

    assert_no_difference("Review.count") do
      post coach_profile_reviews_url(@coach_profile),
           params: {
             review: {
               rating: 5,
               comment: "Second review."
             }
           }
    end

    assert_redirected_to coach_profile_url(@coach_profile)
  end

  test "coach cannot create review" do
    sign_in @coach

    assert_no_difference("Review.count") do
      post coach_profile_reviews_url(@coach_profile),
           params: {
             review: {
               rating: 5,
               comment: "Coach review."
             }
           }
    end

    assert_redirected_to coach_profile_url(@coach_profile)
  end

  test "review owner can delete review" do
    review = Review.create!(
      user: @student,
      coach_profile: @coach_profile,
      rating: 5,
      comment: "Great coach."
    )

    sign_in @student

    assert_difference("Review.count", -1) do
      delete coach_profile_review_url(
        @coach_profile,
        review
      )
    end

    assert_redirected_to coach_profile_url(@coach_profile)
  end

  test "another user cannot delete review" do
    review = Review.create!(
      user: @student,
      coach_profile: @coach_profile,
      rating: 5,
      comment: "Great coach."
    )

    other_student = User.create!(
      first_name: "Other",
      last_name: "Student",
      email: "other-student@test.com",
      password: "password",
      role: :student
    )

    sign_in other_student

    assert_no_difference("Review.count") do
      delete coach_profile_review_url(
        @coach_profile,
        review
      )
    end

    assert_redirected_to coach_profile_url(@coach_profile)
  end
end
