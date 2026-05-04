require "test_helper"

class AssetClassCharacteristicTest < ActiveSupport::TestCase
  test "valid with an asset_class and characteristic" do
    assert build(:asset_class_characteristic).valid?
  end

  test "invalid when the same characteristic is assigned to the same asset class twice" do
    acc = create(:asset_class_characteristic)
    duplicate = build(:asset_class_characteristic,
      asset_class:    acc.asset_class,
      characteristic: acc.characteristic)
    assert_not duplicate.valid?
  end
end
