class Post < ApplicationRecord
  belongs_to :user

  enum :category, {
    movies: 0,
    series: 1,
    games: 2,
    ai: 3,
  }

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_one_attached :image
  attr_accessor :remove_image

  validates :title, presence: true, length: { minimum: 5, maximum: 150 }
  validates :body, presence: true, length: { minimum: 10 }
  validates :category, presence: true
  validate :acceptable_image

  SORTS = {
    "newest" => "Сначала новые",
    "oldest" => "Сначала старые",
    "discussed" => "Самые обсуждаемые",
    "liked" => "По лайкам"
  }.freeze

  scope :search, ->(query) {
    next all if query.blank?

    pattern = "%#{sanitize_sql_like(query.strip)}%"
    where("LOWER(title) LIKE LOWER(?) OR LOWER(body) LIKE LOWER(?)", pattern, pattern)
  }

  scope :sorted_by, ->(key) {
    case key.to_s
    when "oldest"
      order(created_at: :asc)
    when "discussed"
      order(Arel.sql("(SELECT COUNT(*) FROM comments WHERE comments.post_id = posts.id) DESC"), created_at: :desc)
    when "liked"
      order(Arel.sql("(SELECT COUNT(*) FROM likes WHERE likes.likeable_type = 'Post' AND likes.likeable_id = posts.id) DESC"), created_at: :desc)
    else
      order(created_at: :desc)
    end
  }

  private

  def acceptable_image
    return unless image.attached?

    unless image.content_type.in?(%w[image/jpeg image/png image/webp image/gif])
      errors.add(:image, "должна быть JPEG, PNG, WebP или GIF")
    end

    if image.byte_size > 5.megabytes
      errors.add(:image, "не должна быть больше 5 МБ")
    end
  end
end
