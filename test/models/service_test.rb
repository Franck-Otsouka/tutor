require "test_helper"

class ServiceTest < ActiveSupport::TestCase
  setup do
    @service = services(:one)
  end

  test "valid service" do
    assert @service.valid?
  end

  test "requires a title" do
    @service.title = nil

    assert_not @service.valid?
    assert_includes @service.errors[:title], "can't be blank"
  end

  test "requires a description" do
    @service.description = nil

    assert_not @service.valid?
    assert_includes @service.errors[:description], "can't be blank"
  end

  test "requires a duration" do
    @service.duration = nil

    assert_not @service.valid?
    assert_includes @service.errors[:duration], "can't be blank"
  end

  test "requires a positive duration" do
    @service.duration = 0

    assert_not @service.valid?
  end

  test "does not allow a negative duration" do
    @service.duration = -30

    assert_not @service.valid?
  end

  test "requires a price" do
    @service.price = nil

    assert_not @service.valid?
    assert_includes @service.errors[:price], "can't be blank"
  end

  test "does not allow a negative price" do
    @service.price = -1

    assert_not @service.valid?
  end

  test "allows a price of zero" do
    @service.price = 0

    assert @service.valid?
  end

  test "enforces maximum title length" do
    @service.title = "a" * 101

    assert_not @service.valid?
  end

  test "enforces maximum description length" do
    @service.description = "a" * 2001

    assert_not @service.valid?
  end
end
