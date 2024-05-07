class Public::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
  end

  def edit
    @user = current_user
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "ユーザー情報が更新されました"
    else
      render "edit"
    end
  end

  def unsubscribe
  end

  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理が完了しました"
    redirect_to root_path
  end

  private

  def set_user
    name_str = params[:name]
    sanitized_name_str = name_str.gsub(/[^a-zA-Z0-9_]/, '')
    name_sym = sanitized_name_str.to_sym
    @user = User.find_by(name: name_sym)
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
