class User < ApplicationRecord

  validates :pseudo, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-_]+\z/i }
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true, allow_nil: true
  has_secure_password

end
