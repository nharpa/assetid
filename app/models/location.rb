# Represents a physical plant or facility (e.g. Hillview Water Treatment Plant).
# Serves as the top-level geographic grouping for all assets.
# Deletion is blocked if assets are still associated (restrict_with_error).
class Location < ApplicationRecord
  has_many :assets, dependent: :restrict_with_error

  validates :plant_name, presence: true
  validates :suburb, presence: true

  def display_name
    plant_name
  end
end
