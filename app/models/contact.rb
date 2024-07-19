class Contact < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :subject, presence: true, length: { maximum: 30 }
  validates :message, presence: true
end
