require "test_helper"

class AssetTest < ActiveSupport::TestCase
  setup do
    @location    = create(:location)
    @asset_class = create(:asset_class)
  end

  test "valid with all required attributes" do
    assert build(:asset, location: @location, asset_class: @asset_class).valid?
  end

  test "invalid without asset_tag" do
    assert_not build(:asset, asset_tag: nil, location: @location, asset_class: @asset_class).valid?
  end

  test "invalid without name" do
    assert_not build(:asset, name: nil, location: @location, asset_class: @asset_class).valid?
  end

  test "invalid with duplicate asset_tag" do
    create(:asset, asset_tag: "DUPE-001", location: @location, asset_class: @asset_class)
    assert_not build(:asset, asset_tag: "DUPE-001", location: @location, asset_class: @asset_class).valid?
  end

  test "invalid with unrecognized status" do
    assert_not build(:asset, status: "broken", location: @location, asset_class: @asset_class).valid?
  end

  test "to_param returns asset_tag" do
    asset = build(:asset, asset_tag: "HV-PUMP-001")
    assert_equal "HV-PUMP-001", asset.to_param
  end

  test "ancestor_chain is empty for a root asset" do
    root = create(:asset, location: @location, asset_class: @asset_class)
    assert_equal [], root.ancestor_chain
  end

  test "ancestor_chain returns ancestors ordered from root down to parent" do
    root = create(:asset, location: @location, asset_class: @asset_class)
    mid  = create(:asset, location: @location, asset_class: @asset_class, parent_asset: root)
    leaf = create(:asset, location: @location, asset_class: @asset_class, parent_asset: mid)

    assert_equal [ root, mid ], leaf.ancestor_chain
  end

  test "root_ancestor returns self when asset has no parent" do
    root = create(:asset, location: @location, asset_class: @asset_class)
    assert_equal root, root.root_ancestor
  end

  test "root_ancestor traverses to the top of the hierarchy" do
    root = create(:asset, location: @location, asset_class: @asset_class)
    mid  = create(:asset, location: @location, asset_class: @asset_class, parent_asset: root)
    leaf = create(:asset, location: @location, asset_class: @asset_class, parent_asset: mid)

    assert_equal root, leaf.root_ancestor
  end

  test "ancestor_chain does not loop on circular parent references" do
    a = create(:asset, location: @location, asset_class: @asset_class)
    b = create(:asset, location: @location, asset_class: @asset_class, parent_asset: a)
    Asset.where(id: a.id).update_all(parent_asset_id: b.id)
    a.reload

    assert_nothing_raised { a.ancestor_chain }
  end

  test "root_ancestor does not loop on circular parent references" do
    a = create(:asset, location: @location, asset_class: @asset_class)
    b = create(:asset, location: @location, asset_class: @asset_class, parent_asset: a)
    Asset.where(id: a.id).update_all(parent_asset_id: b.id)
    a.reload

    assert_nothing_raised { a.root_ancestor }
  end
end
