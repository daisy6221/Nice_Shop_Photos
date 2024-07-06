class Contact < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true
  validates :subject, presence: true, length: { maximum: 30 }
  validates :messages, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
end
