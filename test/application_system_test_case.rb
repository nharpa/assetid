require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 900 ]

  # System tests disable database transactions, so data from one test persists
  # into the next. Truncate all application tables after each test to ensure
  # a clean slate. PRAGMA foreign_keys OFF allows deleting in any order.
  teardown do
    conn = ActiveRecord::Base.connection
    conn.execute("PRAGMA foreign_keys = OFF")
    %w[asset_characteristic_values asset_class_characteristics
       characteristic_allowed_values assets asset_classes
       characteristics locations users].each { |t| conn.execute("DELETE FROM #{t}") }
    conn.execute("PRAGMA foreign_keys = ON")
  end

  def log_in_as(user, password: "password123")
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_button "Log In"
    assert_text user.name  # confirms login succeeded before test body continues
  end
end
