class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @posts = @user.posts.page(params[:page]).per(10)
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

  def destroy
    @user.destroy
    redirect_to root_path, notice: "ユーザーを削除しました"
  end

  private

  def set_user
    name_str = params[:name]
    sanitized_name_str = name_str.gsub(/[^a-zA-Z0-9_]/, '')
    name_sym = sanitized_name_str.to_sym
    @user = User.find_by(name: name_sym)
  end

  def ensure_correct_user
    unless @user == current_user
      redirect_to user_path(@user), notice: "ユーザー情報が一致しませんでした"
    end
  end

  def ensure_guest_user
    if @user.email == "guest@example.com"
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
