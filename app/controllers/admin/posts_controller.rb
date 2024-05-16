class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @posts = Post.includes(:photos).all.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def edit
    @post = Post.includes(:photos).find(params[:id])
    @post.photos.each do |photo|
      photo.image.cache!
    end
  end

  def update
    @post = Post.includes(:photos).find(params[:id])
    @user = User.find(@post.user_id)
    if @post.update(post_params)
      redirect_to admin_post_path(@post.id), notice: '投稿が更新されました'
    else
      render "edit", notice: '投稿に失敗しました'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to admin_posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :shop_name, :address, :body, photos_attributes: [:id, :_destroy, :image, :image_cache])
  end
end
