require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "valid with required attributes" do
    assert build(:location).valid?
  end

  test "invalid without plant_name" do
    assert_not build(:location, plant_name: nil).valid?
  end

  test "invalid without suburb" do
    assert_not build(:location, suburb: nil).valid?
  end
end
