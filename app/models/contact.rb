class Contact < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :subject, presence: true, length: { maximum: 30 }
  validates :message, presence: true
end
