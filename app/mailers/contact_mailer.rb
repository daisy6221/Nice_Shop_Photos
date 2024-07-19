class ContactMailer < ApplicationMailer
  def send_mail(contact)
    @contact = contact
    mail to: ENV['MAIL_ADDRESS'], subject: '【お問い合わせ】' + @contact.subject
  end

  def done_mail(contact)
    @contact = contact
    mail to: contact.email, subject: '【NiceShopPhotos】お問い合わせを受け付けました'
  end
end
