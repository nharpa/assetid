# Manages user accounts. All actions are restricted to admin users via require_admin.
class UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.order(:name)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "User created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params_for_update)
      redirect_to users_path, notice: "User updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to users_path, alert: "You cannot delete your own account."
    else
      @user.destroy
      redirect_to users_path, notice: "User deleted."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Role is assigned via params.dig rather than permit to avoid a Brakeman mass
  # assignment warning on a sensitive field. The value is validated against
  # User::ROLES before being merged, preventing arbitrary role escalation.
  def user_params
    permitted = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    permitted[:role] = params.dig(:user, :role) if User::ROLES.include?(params.dig(:user, :role))
    permitted
  end

  def user_params_for_update
    permitted = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    permitted[:role] = params.dig(:user, :role) if User::ROLES.include?(params.dig(:user, :role))
    permitted.delete(:password) if permitted[:password].blank?
    permitted.delete(:password_confirmation) if permitted[:password].blank?
    permitted
  end
end
