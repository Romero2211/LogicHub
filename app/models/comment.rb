class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :likes, as: :likeable, dependent: :destroy

  SORTS = {
    "newest" => "Сначала новые",
    "oldest" => "Сначала старые",
    "liked" => "По лайкам"
  }.freeze

  validates :body, presence: true, length: { minimum: 2, maximum: 1000 }

  scope :sorted_by, ->(key) {
    case key.to_s
    when "oldest"
      order(created_at: :asc)
    when "liked"
      order(
        Arel.sql("(SELECT COUNT(*) FROM likes WHERE likes.likeable_type = 'Comment' AND likes.likeable_id = comments.id) DESC"),
        created_at: :desc
      )
    else
      order(created_at: :desc)
    end
  }
end
