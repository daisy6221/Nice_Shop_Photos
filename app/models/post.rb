class Post < ApplicationRecord

  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  accepts_nested_attributes_for :photos, allow_destroy: true

  #画像投稿のバリテーション
  validates_associated :photos
  validates :photos, presence: true, limit: { min: 1, max: 10 }

  validates :title, presence: true, length: { maximum: 30 }
  validates :shop_name, presence: true
  validates :body, presence: true, length: { minimum: 3, maximum: 200 }
  validates :address, presence: true
  geocoded_by :address
  after_validation :geocode


  #並べ替え機能
  scope :latest, -> { order(created_at: :desc)}
  scope :old, -> { order(created_at: :asc)}
  scope :popular, -> { left_outer_joins(:likes).group("posts.id").order("COUNT(likes.id) DESC") }


  def self.search_for(content, tag)
    if tag.present?
      Post.joins(:tags).where("title LIKE ? AND tags.name LIKE ?", "%#{content}%", "%#{tag}%")
    else
      Post.where("title LIKE ?", "%#{content}%")
    end
  end

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
    end
  end

end
