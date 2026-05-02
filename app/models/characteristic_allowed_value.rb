class CharacteristicAllowedValue < ApplicationRecord
  belongs_to :characteristic

  validates :characteristic, presence: true
  validates :value, presence: true
end
