# Join model linking AssetClass to Characteristic.
# Defines which characteristics apply to a given asset class, whether each
# is required, and its display order in forms and views.
# AssetCharacteristicValue references this model rather than Characteristic
# directly, ensuring values are always scoped to the correct class context.
class AssetClassCharacteristic < ApplicationRecord
  belongs_to :asset_class
  belongs_to :characteristic
  has_many :asset_characteristic_values, dependent: :destroy

  validates :asset_class, presence: true
  validates :characteristic, presence: true
  validates :characteristic_id, uniqueness: { scope: :asset_class_id, message: "already assigned to this asset class" }

  delegate :name, :data_type, :unit, to: :characteristic
end
