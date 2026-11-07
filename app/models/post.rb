class Post < ApplicationRecord
  include ImageAttachable

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
  validates :source_url, length: { maximum: 2000 }, allow_blank: true
  validate :source_url_must_be_http_https
  validates_attached_image :image

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

  def source_url_must_be_http_https
    return if source_url.blank?

    uri = URI.parse(source_url.strip)
    unless uri.is_a?(URI::HTTP) && uri.host.present?
      errors.add(:source_url, "должна быть ссылкой http:// или https://")
    end
  rescue URI::InvalidURIError
    errors.add(:source_url, "имеет неверный формат")
  end
end
