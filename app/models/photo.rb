class Photo < ApplicationRecord
  belongs_to :post
  mount_uploader :image, ImageUploader

  validates :image, presence: true
end