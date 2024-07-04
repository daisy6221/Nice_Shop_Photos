module Public::NotificationsHelper
  def notification_message(notification)
    case notification.notifiable_type
    when "Post"
      "フォローしている#{notification.notifiable.user.name}さんが新規投稿しました"
    when "PostComment"
      "#{notification.notifiable.user.name}さんにコメントされました"
    else
      "#{notification.notifiable.user.name}さんにいいねされました"
    end
  end
end
