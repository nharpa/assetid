class AssetCharacteristicValue < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_class_characteristic

  delegate :characteristic, to: :asset_class_characteristic

  validates :asset, presence: true
  validates :asset_class_characteristic, presence: true
  validates :value, presence: true
  validates :asset_class_characteristic_id, uniqueness: { scope: :asset_id }
  validate :value_matches_data_type
  validate :value_in_allowed_values, if: -> { characteristic&.data_type == "enum" }

  private

  def value_matches_data_type
    return if value.blank? || characteristic.nil?

    case characteristic.data_type
    when "integer"
      errors.add(:value, "must be a whole number") unless value.match?(/\A-?\d+\z/)
    when "decimal"
      errors.add(:value, "must be a number") unless value.match?(/\A-?\d+(\.\d+)?\z/)
    when "boolean"
      errors.add(:value, "must be true or false") unless %w[true false].include?(value.downcase)
    when "date"
      begin
        Date.parse(value)
      rescue ArgumentError
        errors.add(:value, "must be a valid date (YYYY-MM-DD)")
      end
    end
  end

  def value_in_allowed_values
    allowed = characteristic.characteristic_allowed_values.pluck(:value)
    errors.add(:value, "must be one of: #{allowed.join(', ')}") unless allowed.include?(value)
  end
end
