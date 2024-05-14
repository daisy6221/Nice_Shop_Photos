class Post < ApplicationRecord

  belongs_to :user
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true
  #画像投稿のバリテーション
  validates_associated :photos
  validates :photos, presence: true

  validates :title, presence: true, length: { maximum: 30 }
  validates :shop_name, presence: true, length: { maximum: 30 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { minimum: 3, maximum: 200 }

  def self.search_for(content)
    Post.where("title LIKE?", "%" + content + "%")
  end
end
