class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user

  def create
    
  end

  def destroy
  end

  def check_guest_user
    if current_user.guest?
      redirect_to root_path, alert: "コメントをする場合は会員登録を行ってください"
    end
  end

end
