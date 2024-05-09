class Public::PostsController < ApplicationController
  def new
    @post = Post.new
    @post_photo = @post.photos.build
  end

  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    if post.save
      params[:photos][:image].each do |image|
        @post.photos.create(image: image, post_id: post.id)
      end
      redirect_to post_path(post.id)
    else
      flash[:notice] = "投稿に失敗しました"
      render "new"
    end
  end

  def index
    @posts = Post.includes(:photos).all.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def edit
    @post = Post.includes(:photos).find(params[:id])
  end

  def update
    post = Post.includes(:photos).find(params[:id])
    post.user_id = current_user.id
    if post.update(post_params)
      if params[:photos][:image].present?
        params[:photos][:image].each do |image|
          post.photos.create(image: image, post_id: post.id)
        end
      end
      redirect_to post_path(post.id), notice: '投稿が更新されました'
    else
      render "edit", notice: '投稿に失敗しました'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def post_params
    params.require(:post).permit(:title, :shop_name, :address, :body, photos_attributes: [:image])
  end
end
