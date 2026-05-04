require "application_system_test_case"

class AssetsTest < ApplicationSystemTestCase
  setup do
    @admin       = create(:user, :admin)
    @location    = create(:location, plant_name: "Riverside WTP")
    @asset_class = create(:asset_class, name: "Pump")
    log_in_as @admin
  end

  test "can create a new asset and see it on the show page" do
    visit new_asset_path
    fill_in "Asset Tag", with: "SYS-PUMP-001"
    fill_in "Name",      with: "Main Feed Pump"
    select "Pump",         from: "Asset Class"
    select "Riverside WTP", from: "Location"
    select "Active",       from: "Status"
    click_button "Create Asset"

    assert_text "Asset created"
    assert_text "SYS-PUMP-001"
    assert_text "Main Feed Pump"
  end

  test "shows validation errors when required fields are blank" do
    visit new_asset_path
    click_button "Create Asset"
    assert_text "can't be blank"
  end

  test "asset show page displays the hierarchy tree" do
    asset = create(:asset, asset_tag: "TREE-ROOT-001", name: "Root Asset",
                           location: @location, asset_class: @asset_class)
    visit asset_path(asset)
    assert_text "TREE-ROOT-001"
    assert_text "Asset Hierarchy"
  end

  test "can edit an existing asset" do
    asset = create(:asset, asset_tag: "EDIT-001", name: "Old Name",
                           location: @location, asset_class: @asset_class)
    visit edit_asset_path(asset)
    fill_in "Name", with: "Updated Name"
    click_button "Update Asset"

    assert_text "Asset updated"
    assert_text "Updated Name"
  end
end
