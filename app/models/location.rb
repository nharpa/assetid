class Location < ApplicationRecord
  has_many :assets, dependent: :restrict_with_error

  validates :plant_name, presence: true
  validates :suburb, presence: true

  def display_name
    plant_name
  end
end
