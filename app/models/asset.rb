# Represents a physical infrastructure asset (e.g. a pump, valve, or tank).
# Assets exist in a recursive parent-child hierarchy:
#   Plant > Treatment Module > Building > Area > Equipment
# The self-join on parent_asset_id enables this tree structure.
# Characteristic values are stored via AssetCharacteristicValue,
# scoped through AssetClassCharacteristic for type safety.
class Asset < ApplicationRecord
  STATUSES = %w[active inactive planned under_maintenance decommissioned].freeze

  belongs_to :asset_class
  belongs_to :location
  belongs_to :parent_asset, class_name: "Asset", optional: true
  has_many :child_assets, class_name: "Asset", foreign_key: "parent_asset_id", dependent: :nullify
  has_many :asset_characteristic_values, dependent: :destroy

  validates :asset_tag, presence: true, uniqueness: true
  validates :name, presence: true
  validates :asset_class, presence: true
  validates :location, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  # Returns an ordered array of ancestors from root down to the immediate parent.
  # Uses a visited Set to guard against circular parent references in corrupted data.
  def ancestor_chain
    chain = []
    current = parent_asset
    visited = Set.new([ id ])
    while current && !visited.include?(current.id)
      chain.unshift(current)
      visited.add(current.id)
      current = current.parent_asset
    end
    chain
  end

  # Traverses the parent chain to return the top-level ancestor (an asset with no parent).
  # Uses a visited Set to guard against circular references.
  def root_ancestor
    node = self
    visited = Set.new([ id ])
    while node.parent_asset && !visited.include?(node.parent_asset.id)
      visited.add(node.parent_asset.id)
      node = node.parent_asset
    end
    node
  end

  # Overrides Rails' default URL parameter (numeric id) to use asset_tag instead,
  # producing URLs like /register/HV-PUMP-001 across all route helpers.
  def to_param
    asset_tag
  end

  def display_name
    "#{asset_tag} – #{name}"
  end
end
