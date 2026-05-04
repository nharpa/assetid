require "test_helper"

class AssetCharacteristicValueTest < ActiveSupport::TestCase
  # Builds an AssetCharacteristicValue with a characteristic of the given data_type.
  # allowed_values are added when data_type is "enum".
  def build_acv(data_type:, value:, allowed_values: [])
    char  = create(:characteristic, data_type: data_type)
    allowed_values.each { |v| create(:characteristic_allowed_value, characteristic: char, value: v) }
    acc   = create(:asset_class_characteristic, characteristic: char)
    asset = create(:asset, asset_class: acc.asset_class)
    build(:asset_characteristic_value, asset: asset, asset_class_characteristic: acc, value: value)
  end

  # ── String ────────────────────────────────────────────────────────────────

  test "string: accepts any value" do
    assert build_acv(data_type: "string", value: "anything").valid?
  end

  # ── Integer ───────────────────────────────────────────────────────────────

  test "integer: accepts a whole number" do
    assert build_acv(data_type: "integer", value: "42").valid?
  end

  test "integer: accepts a negative whole number" do
    assert build_acv(data_type: "integer", value: "-7").valid?
  end

  test "integer: rejects a decimal" do
    assert_not build_acv(data_type: "integer", value: "3.14").valid?
  end

  test "integer: rejects text" do
    assert_not build_acv(data_type: "integer", value: "abc").valid?
  end

  # ── Decimal ───────────────────────────────────────────────────────────────

  test "decimal: accepts an integer-like value" do
    assert build_acv(data_type: "decimal", value: "100").valid?
  end

  test "decimal: accepts a decimal value" do
    assert build_acv(data_type: "decimal", value: "3.14").valid?
  end

  test "decimal: accepts a negative decimal" do
    assert build_acv(data_type: "decimal", value: "-0.5").valid?
  end

  test "decimal: rejects text" do
    assert_not build_acv(data_type: "decimal", value: "abc").valid?
  end

  # ── Boolean ───────────────────────────────────────────────────────────────

  test "boolean: accepts 'true'" do
    assert build_acv(data_type: "boolean", value: "true").valid?
  end

  test "boolean: accepts 'false'" do
    assert build_acv(data_type: "boolean", value: "false").valid?
  end

  test "boolean: rejects arbitrary strings" do
    assert_not build_acv(data_type: "boolean", value: "yes").valid?
  end

  test "boolean: rejects '1'" do
    assert_not build_acv(data_type: "boolean", value: "1").valid?
  end

  # ── Date ──────────────────────────────────────────────────────────────────

  test "date: accepts a valid ISO date" do
    assert build_acv(data_type: "date", value: "2024-06-15").valid?
  end

  test "date: rejects text that is not a date" do
    assert_not build_acv(data_type: "date", value: "not-a-date").valid?
  end

  # ── Enum ──────────────────────────────────────────────────────────────────

  test "enum: accepts a value in the allowed list" do
    assert build_acv(data_type: "enum", value: "Good", allowed_values: %w[Good Fair Poor]).valid?
  end

  test "enum: rejects a value not in the allowed list" do
    assert_not build_acv(data_type: "enum", value: "Excellent", allowed_values: %w[Good Fair Poor]).valid?
  end

  # ── General ───────────────────────────────────────────────────────────────

  test "invalid without a value" do
    char  = create(:characteristic)
    acc   = create(:asset_class_characteristic, characteristic: char)
    asset = create(:asset, asset_class: acc.asset_class)
    assert_not build(:asset_characteristic_value, asset: asset, asset_class_characteristic: acc, value: nil).valid?
  end

  test "invalid when the same characteristic is recorded twice for the same asset" do
    char  = create(:characteristic)
    acc   = create(:asset_class_characteristic, characteristic: char)
    asset = create(:asset, asset_class: acc.asset_class)
    create(:asset_characteristic_value, asset: asset, asset_class_characteristic: acc, value: "first")
    assert_not build(:asset_characteristic_value, asset: asset, asset_class_characteristic: acc, value: "second").valid?
  end
end
