class User < ApplicationRecord
  has_secure_password
  has_many :artworks, foreign_key: :user_id
  has_many :orders
  enum :role, {:artist=>0, :buyer=>1, :admin=>2}

  validates :name, :email, :password_digest, presence: true
  validates :email, uniqueness: true
end
