require "test_helper"

# Verifies the authentication wall: unauthenticated requests redirect to login,
# admin-only routes reject staff users, and session management works end-to-end.
class AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @staff = create(:user, role: "staff")
    @admin = create(:user, :admin)
  end

  # ── Unauthenticated access ─────────────────────────────────────────────────

  test "unauthenticated GET / redirects to login" do
    get root_path
    assert_redirected_to login_path
  end

  test "unauthenticated GET /register redirects to login" do
    get assets_path
    assert_redirected_to login_path
  end

  test "unauthenticated GET /locations redirects to login" do
    get locations_path
    assert_redirected_to login_path
  end

  test "unauthenticated GET /users redirects to login" do
    get users_path
    assert_redirected_to login_path
  end

  # ── Staff access ───────────────────────────────────────────────────────────

  test "staff can access the assets index" do
    post login_path, params: { email: @staff.email, password: "password123" }
    get assets_path
    assert_response :success
  end

  test "staff is redirected away from the users index" do
    post login_path, params: { email: @staff.email, password: "password123" }
    get users_path
    assert_redirected_to root_path
  end

  # ── Admin access ───────────────────────────────────────────────────────────

  test "admin can access the users index" do
    post login_path, params: { email: @admin.email, password: "password123" }
    get users_path
    assert_response :success
  end

  # ── Login / logout mechanics ───────────────────────────────────────────────

  test "login with wrong password returns unprocessable_entity" do
    post login_path, params: { email: @staff.email, password: "wrongpassword" }
    assert_response :unprocessable_entity
  end

  test "login with unknown email returns unprocessable_entity" do
    post login_path, params: { email: "nobody@example.com", password: "password123" }
    assert_response :unprocessable_entity
  end

  test "logout clears session and redirects to login" do
    post login_path, params: { email: @staff.email, password: "password123" }
    delete logout_path
    get root_path
    assert_redirected_to login_path
  end

  test "visiting login while already authenticated redirects to root" do
    post login_path, params: { email: @staff.email, password: "password123" }
    get login_path
    assert_redirected_to root_path
  end
end
