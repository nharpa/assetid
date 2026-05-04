require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  setup do
    @user = create(:user, :admin)
  end

  test "successful login redirects to the assets index" do
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password123"
    click_button "Log In"
    assert_text "Welcome back"
    assert_current_path root_path
  end

  test "failed login shows an error and stays on the login page" do
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "wrongpassword"
    click_button "Log In"
    assert_text "Invalid email or password"
    assert_current_path login_path
  end

  test "logout clears the session and redirects to login" do
    log_in_as @user
    click_button "Log out"
    assert_current_path login_path
  end
end
