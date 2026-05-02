class AssetClassCharacteristic < ApplicationRecord
  belongs_to :asset_class
  belongs_to :characteristic
  has_many :asset_characteristic_values, dependent: :destroy

  validates :asset_class, presence: true
  validates :characteristic, presence: true
  validates :characteristic_id, uniqueness: { scope: :asset_class_id, message: "already assigned to this asset class" }

  delegate :name, :data_type, :unit, to: :characteristic
end
