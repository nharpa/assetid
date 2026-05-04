require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with all required attributes" do
    assert build(:user).valid?
  end

  test "invalid without name" do
    assert_not build(:user, name: nil).valid?
  end

  test "invalid without email" do
    assert_not build(:user, email: nil).valid?
  end

  test "invalid with malformed email" do
    assert_not build(:user, email: "notanemail").valid?
  end

  test "invalid with duplicate email case-insensitively" do
    create(:user, email: "test@example.com")
    assert_not build(:user, email: "TEST@EXAMPLE.COM").valid?
  end

  test "invalid with unrecognized role" do
    assert_not build(:user, role: "superuser").valid?
  end

  test "email is downcased before save" do
    user = create(:user, email: "UPPER@EXAMPLE.COM")
    assert_equal "upper@example.com", user.email
  end

  test "admin? returns true for admin role" do
    assert build(:user, :admin).admin?
  end

  test "admin? returns false for staff role" do
    assert_not build(:user, role: "staff").admin?
  end
end
