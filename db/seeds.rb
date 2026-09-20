# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
require "open-uri"
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

puts "🌱 Seeding Tutor..."

# ---------------------------------------------------------
# Helpers
# ---------------------------------------------------------

# ---------------------------------------------------------
# Helpers
# ---------------------------------------------------------

def find_or_create_user!(email:, first_name:, last_name:, role:, password: "Password123!")
  user = User.find_or_initialize_by(email: email)

  user.assign_attributes(
    first_name: first_name,
    last_name: last_name,
    role: role,
    password: password,
    password_confirmation: password,
    bio: Faker::Lorem.paragraph(sentence_count: 2)
  )

  user.save!
  user
end

def attach_fake_avatar(user, image_number)
  return if user.avatar.attached?

  user.avatar.attach(
    io: URI.open("https://i.pravatar.cc/300?img=#{image_number}"),
    filename: "avatar-#{user.id}.jpg",
    content_type: "image/jpeg"
  )

  puts "  📸 Avatar added for #{user.email}"
end

# ---------------------------------------------------------
# Users
# ---------------------------------------------------------

puts "Creating users..."

# Adjust these values if your enum uses different names.
admin = find_or_create_user!(
  email: "admin@tutor.test",
  first_name: "Admin",
  last_name: "Tutor",
  role: :admin
)

attach_fake_avatar(admin, 1)

coaches = []

10.times do |i|
  coach = find_or_create_user!(
    email: "coach#{i + 1}@tutor.test",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: :coach
  )

  attach_fake_avatar(coach, i + 2)

  coaches << coach
end

students = []

20.times do |i|
  student = find_or_create_user!(
    email: "student#{i + 1}@tutor.test",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: :student
  )

  attach_fake_avatar(student, i + 12)

  students << student
end

puts "  Users: #{User.count}"

# ---------------------------------------------------------
# Coach Profiles
# ---------------------------------------------------------

puts "Creating coach profiles..."

coach_profiles = coaches.map do |coach|
  CoachProfile.find_or_create_by!(user: coach) do |profile|
    profile.headline = [
      "Experienced #{Faker::Job.title}",
      "Professional Online Tutor",
      "Passionate Educator",
      "Certified Learning Coach",
      "Expert Private Tutor"
    ].sample

    profile.description = Faker::Lorem.paragraphs(number: 3).join("\n\n")
    profile.hourly_rate = rand(15..80)
    profile.years_experience = rand(1..15)
    profile.verified = [true, true, true, false].sample
  end
end

puts "  Coach Profiles: #{CoachProfile.count}"

# ---------------------------------------------------------
# Categories
# ---------------------------------------------------------

puts "Creating categories..."

category_names = [
  "Mathematics",
  "Science",
  "English",
  "Programming",
  "Web Development",
  "Languages",
  "Business",
  "Music",
  "Design",
  "Data Science"
]

categories = category_names.map do |name|
  Category.find_or_create_by!(name: name)
end

puts "  Categories: #{Category.count}"

# ---------------------------------------------------------
# Services
# ---------------------------------------------------------

puts "Creating services..."

service_titles = [
  "Private Tutoring Session",
  "Beginner Course",
  "Advanced Coaching",
  "Exam Preparation",
  "Homework Support",
  "Career Coaching",
  "One-on-One Workshop"
]

coach_profiles.each do |profile|
  rand(2..4).times do
    category = categories.sample

    Service.create!(
      coach_profile: profile,
      category: category,
      title: "#{service_titles.sample} - #{category.name}",
      description: Faker::Lorem.paragraph(sentence_count: 3),
      duration: [30, 45, 60, 90, 120].sample,
      price: rand(20..100),
      active: true
    )
  end
end

puts "  Services: #{Service.count}"

# ---------------------------------------------------------
# Bookings
# ---------------------------------------------------------

puts "Creating bookings..."

services = Service.all

students.each_with_index do |student, index|
  rand(1..3).times do
    service = services.sample

    start_time =
      if index.even?
        rand(1..14).days.from_now.change(
          hour: [9, 10, 11, 13, 14, 15, 17, 18].sample,
          min: [0, 30].sample
        )
      else
        rand(1..14).days.ago.change(
          hour: [9, 10, 11, 13, 14, 15, 17, 18].sample,
          min: [0, 30].sample
        )
      end

    end_time = start_time + service.duration.minutes

    status =
      if start_time < Time.current
        ["completed", "completed", "cancelled"].sample
      else
        ["pending", "confirmed", "confirmed"].sample
      end

    Booking.create!(
      student: student,
      service: service,
      start_time: start_time,
      end_time: end_time,
      status: status
    )
  end
end

puts "  Bookings: #{Booking.count}"

# ---------------------------------------------------------
# Membership Plans
# ---------------------------------------------------------

puts "Creating membership plans..."

plans = [
  {
    name: "Free",
    description: "Access to basic Tutor community features.",
    monthly_price: 0
  },
  {
    name: "Basic",
    description: "Access to additional learning content and communities.",
    monthly_price: 9.99
  },
  {
    name: "Premium",
    description: "Full access to premium educational content and communities.",
    monthly_price: 19.99
  }
]

membership_plans = plans.map do |plan|
  MembershipPlan.find_or_create_by!(name: plan[:name]) do |record|
    record.description = plan[:description]
    record.monthly_price = plan[:monthly_price]
  end
end

puts "  Membership Plans: #{MembershipPlan.count}"

# ---------------------------------------------------------
# Subscriptions
# ---------------------------------------------------------

puts "Creating subscriptions..."

paid_plans = membership_plans.reject { |plan| plan.name == "Free" }

students.each_with_index do |student, index|
  next unless index < 15

  plan = paid_plans.sample

  Subscription.find_or_create_by!(
    user: student,
    membership_plan: plan
  ) do |subscription|
    subscription.status = ["active", "active", "active", "cancelled"].sample
    subscription.stripe_subscription_id =
      "sub_test_#{SecureRandom.hex(10)}"
  end
end

puts "  Subscriptions: #{Subscription.count}"

# ---------------------------------------------------------
# Videos
# ---------------------------------------------------------

puts "Creating videos..."

video_topics = [
  "Introduction to",
  "Understanding",
  "Complete Guide to",
  "Advanced",
  "Beginner's Guide to",
  "Practical",
  "Mastering"
]

coach_profiles.each do |profile|
  rand(1..3).times do
    category = categories.sample

    Video.create!(
      coach_profile: profile,
      title: "#{video_topics.sample} #{category.name}",
      description: Faker::Lorem.paragraph(sentence_count: 3),
      published: [true, true, true, false].sample,
      visibility: [0, 0, 0, 1].sample
    )
  end
end

puts "  Videos: #{Video.count}"

# ---------------------------------------------------------
# Live Streams
# ---------------------------------------------------------

puts "Creating live streams..."

stream_topics = [
  "Live Q&A",
  "Interactive Workshop",
  "Study Session",
  "Ask Me Anything",
  "Live Coding Session",
  "Exam Preparation",
  "Weekly Coaching"
]

coach_profiles.each do |profile|
  rand(1..2).times do
    Stream.create!(
      coach_profile: profile,
      title: "#{stream_topics.sample}: #{categories.sample.name}",
      description: Faker::Lorem.paragraph(sentence_count: 2),
      scheduled_at: rand(1..14).days.from_now,
      visibility: [0, 0, 1].sample
    )
  end
end

puts "  Live Streams: #{Stream.count}"

# ---------------------------------------------------------
# Communities
# ---------------------------------------------------------

puts "Creating communities..."

community_data = [
  ["Programming Hub", "A community for programmers and developers."],
  ["Mathematics Club", "Discuss mathematics, problem solving and exams."],
  ["English Learners", "Practice English and improve communication skills."],
  ["Data Science Community", "Learn and discuss data science and analytics."],
  ["Student Lounge", "A general community for Tutor students."]
]

communities = community_data.map do |name, description|
  CommunityGroup.find_or_create_by!(name: name) do |group|
    group.description = description
    group.membership_required = [true, false].sample
  end
end

puts "  Communities: #{CommunityGroup.count}"

# ---------------------------------------------------------
# Group Memberships
# ---------------------------------------------------------

puts "Creating community memberships..."

all_users = [admin] + coaches + students

communities.each do |community|
  members = all_users.sample(rand(5..12))

  members.each do |user|
    GroupMembership.find_or_create_by!(
      user: user,
      community_group: community
    )
  end
end

puts "  Group Memberships: #{GroupMembership.count}"

# ---------------------------------------------------------
# Community Posts
# ---------------------------------------------------------

puts "Creating community posts..."

communities.each do |community|
  members = community.users.to_a

  rand(3..7).times do
    user = members.sample

    Post.create!(
      user: user,
      community_group: community,
      content: [
        Faker::Lorem.paragraph(sentence_count: 2),
        "What is everyone currently learning?",
        "Does anyone have recommendations for learning #{categories.sample.name}?",
        "I just completed my latest lesson. Happy to share what I learned!",
        "Looking for study partners this week."
      ].sample
    )
  end
end

puts "  Posts: #{Post.count}"

# ---------------------------------------------------------
# Comments
# ---------------------------------------------------------

puts "Creating comments..."

posts = Post.all

posts.each do |post|
  members = post.community_group.users.to_a

  rand(0..4).times do
    next if members.empty?

    Comment.create!(
      user: members.sample,
      post: post,
      content: [
        "Great post!",
        "Thanks for sharing.",
        "This was really helpful.",
        "I had the same question.",
        "Good luck with your studies!",
        Faker::Lorem.sentence
      ].sample
    )
  end
end

puts "  Comments: #{Comment.count}"

# ---------------------------------------------------------
# Reviews
# ---------------------------------------------------------

puts "Creating coach reviews..."

coach_profiles.each do |coach_profile|
  # Give each coach 3–8 reviews
  reviewers = students.sample(rand(3..8))

  reviewers.each do |student|
    Review.find_or_create_by!(
      user: student,
      coach_profile: coach_profile
    ) do |review|
      review.rating = rand(4..5)
      review.comment = [
        "Excellent coach and very helpful!",
        "Great explanation and easy to understand.",
        "Really enjoyed the session.",
        "Very knowledgeable and patient.",
        "Highly recommended!",
        "The lessons were clear and practical.",
        "Great experience overall."
      ].sample
    end
  end
end

puts "  Reviews: #{Review.count}"

# ---------------------------------------------------------
# Summary
# ---------------------------------------------------------

puts
puts "=========================================="
puts "          TUTOR SEED COMPLETE"
puts "=========================================="
puts "Users:              #{User.count}"
puts "Coach Profiles:     #{CoachProfile.count}"
puts "Categories:         #{Category.count}"
puts "Services:           #{Service.count}"
puts "Bookings:           #{Booking.count}"
puts "Membership Plans:   #{MembershipPlan.count}"
puts "Subscriptions:      #{Subscription.count}"
puts "Videos:             #{Video.count}"
puts "Live Streams:       #{Stream.count}"
puts "Communities:        #{CommunityGroup.count}"
puts "Group Memberships:  #{GroupMembership.count}"
puts "Posts:              #{Post.count}"
puts "Comments:           #{Comment.count}"
puts "=========================================="
puts
puts "Development accounts:"
puts "Admin:   admin@tutor.test / Password123!"
puts "Coach:   coach1@tutor.test / Password123!"
puts "Student: student1@tutor.test / Password123!"
puts "=========================================="
