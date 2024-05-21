class Post < ApplicationRecord

  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  accepts_nested_attributes_for :photos, allow_destroy: true

  #画像投稿のバリテーション
  validates_associated :photos
  validates :photos, presence: true, limit: { min: 1, max: 10 }

  validates :title, presence: true, length: { maximum: 30 }
  validates :shop_name, presence: true, length: { maximum: 30 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { minimum: 3, maximum: 200 }

  def self.search_for(content)
    Post.where("title LIKE?", "%" + content + "%")
  end

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end
