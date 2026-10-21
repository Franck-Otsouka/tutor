# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_27_144704) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.bigint "service_id", null: false
    t.datetime "start_time"
    t.string "status", default: "pending"
    t.bigint "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_bookings_on_service_id"
    t.index ["student_id"], name: "index_bookings_on_student_id"
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "classroom_memberships", force: :cascade do |t|
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["classroom_id"], name: "index_classroom_memberships_on_classroom_id"
    t.index ["user_id", "classroom_id"], name: "index_classroom_memberships_on_user_id_and_classroom_id", unique: true
    t.index ["user_id"], name: "index_classroom_memberships_on_user_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.boolean "private", default: true
    t.bigint "representative_id", null: false
    t.datetime "updated_at", null: false
    t.index ["representative_id"], name: "index_classrooms_on_representative_id"
  end

  create_table "coach_content_likes", force: :cascade do |t|
    t.bigint "coach_content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["coach_content_id"], name: "index_coach_content_likes_on_coach_content_id"
    t.index ["user_id", "coach_content_id"], name: "index_coach_content_likes_on_user_id_and_coach_content_id", unique: true
    t.index ["user_id"], name: "index_coach_content_likes_on_user_id"
  end

  create_table "coach_contents", force: :cascade do |t|
    t.text "content"
    t.integer "content_type"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "views_count", default: 0, null: false
    t.integer "visibility"
    t.index ["user_id"], name: "index_coach_contents_on_user_id"
  end

  create_table "coach_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "headline"
    t.decimal "hourly_rate"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "verified"
    t.integer "years_experience"
    t.index ["user_id"], name: "index_coach_profiles_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "coach_content_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "post_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["coach_content_id"], name: "index_comments_on_coach_content_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "community_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "membership_required"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "community_post_replies", force: :cascade do |t|
    t.bigint "community_post_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["community_post_id"], name: "index_community_post_replies_on_community_post_id"
    t.index ["user_id"], name: "index_community_post_replies_on_user_id"
  end

  create_table "community_posts", force: :cascade do |t|
    t.bigint "community_group_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "link_url"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["community_group_id"], name: "index_community_posts_on_community_group_id"
    t.index ["user_id"], name: "index_community_posts_on_user_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "community_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["community_group_id"], name: "index_group_memberships_on_community_group_id"
    t.index ["user_id", "community_group_id"], name: "index_group_memberships_on_user_and_community", unique: true
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "membership_plans", force: :cascade do |t|
    t.bigint "coach_profile_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.decimal "monthly_price"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["coach_profile_id"], name: "index_membership_plans_on_coach_profile_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "community_group_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["community_group_id"], name: "index_posts_on_community_group_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "coach_profile_id", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["coach_profile_id"], name: "index_reviews_on_coach_profile_id"
    t.index ["user_id", "coach_profile_id"], name: "index_reviews_on_user_id_and_coach_profile_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.boolean "active"
    t.bigint "category_id", null: false
    t.bigint "coach_profile_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration"
    t.decimal "price"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_services_on_category_id"
    t.index ["coach_profile_id"], name: "index_services_on_coach_profile_id"
  end

  create_table "streams", force: :cascade do |t|
    t.bigint "coach_profile_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "scheduled_at"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "visibility"
    t.index ["coach_profile_id"], name: "index_streams_on_coach_profile_id"
  end

  create_table "student_profiles", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.text "learning_goals"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_student_profiles_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "membership_plan_id", null: false
    t.string "status"
    t.string "stripe_subscription_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["membership_plan_id"], name: "index_subscriptions_on_membership_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.bigint "coach_profile_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "published"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "visibility"
    t.index ["coach_profile_id"], name: "index_videos_on_coach_profile_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "services"
  add_foreign_key "bookings", "users", column: "student_id"
  add_foreign_key "classroom_memberships", "classrooms"
  add_foreign_key "classroom_memberships", "users"
  add_foreign_key "classrooms", "users", column: "representative_id"
  add_foreign_key "coach_content_likes", "coach_contents"
  add_foreign_key "coach_content_likes", "users"
  add_foreign_key "coach_contents", "users"
  add_foreign_key "coach_profiles", "users"
  add_foreign_key "comments", "coach_contents"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "community_post_replies", "community_posts"
  add_foreign_key "community_post_replies", "users"
  add_foreign_key "community_posts", "community_groups"
  add_foreign_key "community_posts", "users"
  add_foreign_key "group_memberships", "community_groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "membership_plans", "coach_profiles"
  add_foreign_key "posts", "community_groups"
  add_foreign_key "posts", "users"
  add_foreign_key "reviews", "coach_profiles"
  add_foreign_key "reviews", "users"
  add_foreign_key "services", "categories"
  add_foreign_key "services", "coach_profiles"
  add_foreign_key "streams", "coach_profiles"
  add_foreign_key "student_profiles", "users"
  add_foreign_key "subscriptions", "membership_plans"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "videos", "coach_profiles"
end
