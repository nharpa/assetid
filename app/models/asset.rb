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

  def ancestor_chain
    chain = []
    current = parent_asset
    visited = Set.new([id])
    while current && !visited.include?(current.id)
      chain.unshift(current)
      visited.add(current.id)
      current = current.parent_asset
    end
    chain
  end

  def root_ancestor
    node = self
    visited = Set.new([id])
    while node.parent_asset && !visited.include?(node.parent_asset.id)
      visited.add(node.parent_asset.id)
      node = node.parent_asset
    end
    node
  end

  def to_param
    asset_tag
  end

  def display_name
    "#{asset_tag} – #{name}"
  end
end
