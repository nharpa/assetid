# Defines a category of asset (e.g. Pump, Valve, Tank, Building, Plant).
# Links to Characteristic via AssetClassCharacteristic to define which
# typed attributes apply to assets of this class.
# Deletion is blocked if assets are still associated (restrict_with_error).
class AssetClass < ApplicationRecord
  has_many :asset_class_characteristics, -> { order(:display_order) }, dependent: :destroy
  has_many :characteristics, through: :asset_class_characteristics
  has_many :assets, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
