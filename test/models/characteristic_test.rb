require "test_helper"

class CharacteristicTest < ActiveSupport::TestCase
  test "valid with name and data_type" do
    assert build(:characteristic).valid?
  end

  test "invalid without name" do
    assert_not build(:characteristic, name: nil).valid?
  end

  test "invalid without data_type" do
    assert_not build(:characteristic, data_type: nil).valid?
  end

  test "invalid with an unrecognized data_type" do
    assert_not build(:characteristic, data_type: "text").valid?
  end

  Characteristic::DATA_TYPES.each do |type|
    test "accepts data_type '#{type}'" do
      assert build(:characteristic, data_type: type).valid?
    end
  end
end
