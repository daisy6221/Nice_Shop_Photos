class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :posts, through: :post_tags

  validates :name, uniqueness: true, presence: true

  scope :popular, -> { left_outer_joins(:posts).group("tags.id").order("COUNT(posts.id) DESC") }
end