class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user, only: [:new]
  before_action :ensure_correct_user, only: [:edit]

  def new
    @post = Post.new
    @post.photos.build
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to post_path(@post.id)
    else
      flash[:notice] = "投稿に失敗しました"
      redirect_to new_post_path
    end
  end

  def index
    @posts = Post.includes(:photos).all.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.includes(:photos).find(params[:id])
    @post.photos.each do |photo|
      photo.image.cache!
    end
  end

  def update
    @post = Post.includes(:photos).find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: '投稿が更新されました'
    else
      render "edit", notice: '投稿に失敗しました'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  private

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to posts_path, notice: "ユーザー情報が一致しませんでした"
    end
  end

  def check_guest_user
    if current_user.guest?
      redirect_to root_path, alert: "投稿する場合は会員登録を行ってください"
    end
  end

  def post_params
    params.require(:post).permit(:title, :shop_name, :address, :body, photos_attributes: [:id, :_destroy, :image, :image_cache]).merge(user_id: current_user.id)
  end
end
