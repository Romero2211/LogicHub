class User < ApplicationRecord
  has_secure_password

  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
