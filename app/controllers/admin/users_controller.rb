class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def update
    if @user.update(admin_user_params)
      redirect_to admin_user_path(@user), notice: "ユーザー情報を更新しました"
    else
      redirect_to request.referer, alert: "更新に失敗しました。入力内容を見直してください"
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_top_path, notice: "ユーザーの退会処理が完了しました"
  end

  private

  def set_user
    @user = User.find_by(name: params[:name])
  end

  def admin_user_params
    params.require(:user).permit(:name, :profile_image, :email)
  end

end
