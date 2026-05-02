class User < ApplicationRecord
  has_secure_password

  ROLES = %w[admin staff].freeze

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: ROLES }

  before_save { self.email = email.downcase }

  def admin?
    role == "admin"
  end
end
