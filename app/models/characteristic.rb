# Defines a typed attribute that can be assigned to an AssetClass
# (e.g. Manufacturer, Capacity, Condition).
# Supported data types: string, integer, decimal, boolean, date, enum.
# Enum characteristics require CharacteristicAllowedValues to constrain valid inputs.
class Characteristic < ApplicationRecord
  DATA_TYPES = %w[string integer decimal boolean date enum].freeze

  has_many :asset_class_characteristics, dependent: :destroy
  has_many :asset_classes, through: :asset_class_characteristics
  has_many :characteristic_allowed_values, dependent: :destroy

  validates :name, presence: true
  validates :data_type, presence: true, inclusion: { in: DATA_TYPES }
end
