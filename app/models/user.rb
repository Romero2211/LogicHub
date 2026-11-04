class User < ApplicationRecord
  has_secure_password

  has_many :posts
  has_many :comments
  has_many :likes, dependent: :destroy
  has_one_attached :avatar

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :nickname,
            uniqueness: { case_sensitive: false, allow_nil: true },
            length: { minimum: 3, maximum: 24, allow_nil: true },
            format: {
              with: /\A[a-zA-Z0-9_]+\z/,
              message: "только латиница, цифры и _",
              allow_nil: true
            }

  before_validation :normalize_nickname

  def display_name
    nickname.presence || email.to_s.split("@").first
  end

  def initials
    display_name.to_s.first.upcase
  end

  def profile_complete?
    nickname.present? && avatar.attached?
  end

  private

  def normalize_nickname
    self.nickname = nickname.to_s.strip.presence
  end
end
