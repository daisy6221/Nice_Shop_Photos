class Post < ApplicationRecord

  belongs_to :user
  has_many :photos, dependent: :destroy
  accepts_nested_attributes_for :photos, allow_destroy: true

  validates :title, presence: true
  validates :shop_name, presence: true
  validates :address, presence: true
  validates :body, presence: true, length: { minimum: 3, maximum: 200 }
end
