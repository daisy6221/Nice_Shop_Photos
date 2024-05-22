class Public::RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user, only: [:create, :destroy, :followings, :followers]
  before_action :set_user, only: [:create, :destroy, :followings, :followers]

  def create
    current_user.follow(@user)
  end

  def destroy
    current_user.unfollow(@user)
  end

  def followings
    @users = @user.followings.page(params[:page]).per(10)
  end

  def followers
    @users = @user.followers.page(params[:page]).per(10)
  end

  private

  def set_user
    @user = User.find_by(name: params[:user_name])
  end

  def check_guest_user
    if current_user.guest?
      redirect_to root_path, alert: "フォロー機能を使用する場合は会員登録を行ってください"
    end
  end
end
