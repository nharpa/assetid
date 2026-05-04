require "test_helper"

class AssetClassTest < ActiveSupport::TestCase
  test "valid with a name" do
    assert build(:asset_class).valid?
  end

  test "invalid without name" do
    assert_not build(:asset_class, name: nil).valid?
  end

  test "invalid with a duplicate name" do
    create(:asset_class, name: "Pump")
    assert_not build(:asset_class, name: "Pump").valid?
  end
end
