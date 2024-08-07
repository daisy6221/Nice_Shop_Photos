class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :likes]
  before_action :ensure_correct_user, only: [:edit]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @posts = @user.posts.where(status: :published).page(params[:page]).per(8).order(created_at: :DESC)
    # マイページ:下書き、非公開一覧用
    @published_posts = @user.posts.where(status: :published).page(params[:page]).per(8).order(created_at: :DESC)
    @draft_posts = @user.posts.where(status: :draft).page(params[:page]).per(8)
    @unpublished_posts = @user.posts.where(status: :unpublished).page(params[:page]).per(8)
  end

  def edit
    @user = current_user
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user), notice: "ユーザー情報が更新されました"
    else
      redirect_to request.referer, alert: "ユーザー名が既に登録済みもしくは誤りがあります。再度入力してください。"
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: "ユーザーの退会処理が完了しました"
  end

  def likes
    likes = Like.where(user_id: @user.id).pluck(:post_id)
    if @user == current_user
      @like_post = Post.where(id: likes).page(params[:page]).per(8).order(created_at: :DESC)
    else
      @like_post = Post.published.where(id: likes).page(params[:page]).per(8).order(created_at: :DESC)
    end
  end

  private

  def set_user
    @user = User.find_by(name: params[:name])
  end

  def ensure_correct_user
    unless @user == current_user
      redirect_to user_path(@user), alert: "ユーザー情報が一致しませんでした"
    end
  end

  def ensure_guest_user
    if @user.email == "guest@example.com"
      redirect_to user_path(current_user) , alert: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
