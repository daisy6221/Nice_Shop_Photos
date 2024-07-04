class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :comment, presence: true, length: { maximum: 100 }

  after_create do
    create_notification(user_id: post.user_id)
  end
end
