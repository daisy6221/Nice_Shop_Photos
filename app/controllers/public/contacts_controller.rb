class Public::ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def confirm
    @contact = Contact.new(contact_params)
    if @contact.invalid?
      render "new"
    end
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      begin
        ContactMailer.done_mail(@contact).deliver_now
        ContactMailer.send_mail(@contact).deliver_now
        redirect_to done_contacts_path
      # rescue StandardError => e
      #   puts "メールの送信に失敗しました。エラー：#{e.message}"
      #   flash.now[:alert] = "メールの送信に失敗しました。メールアドレスを見直してください。"
      #   render "new"
      end
    else
      render "new"
    end
  end

  def back
    @contact = Contact.new(contact_params)
    render "new"
  end

  def done
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
