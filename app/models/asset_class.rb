class AssetClass < ApplicationRecord
  has_many :asset_class_characteristics, -> { order(:display_order) }, dependent: :destroy
  has_many :characteristics, through: :asset_class_characteristics
  has_many :assets, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
