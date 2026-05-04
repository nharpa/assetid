# Stores a permitted value for an enum-type Characteristic
# (e.g. Condition allows "Good", "Fair", "Poor").
# AssetCharacteristicValue validates against these when data_type is "enum".
class CharacteristicAllowedValue < ApplicationRecord
  belongs_to :characteristic

  validates :characteristic, presence: true
  validates :value, presence: true
end
