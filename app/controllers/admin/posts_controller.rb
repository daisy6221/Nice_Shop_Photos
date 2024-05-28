class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:latest]
      @posts = Post.includes(:photos).all.page(params[:page]).per(10).latest
    elsif params[:old]
      @posts = Post.includes(:photos).all.page(params[:page]).per(10).old
    elsif params[:popular]
      @posts = Post.includes(:photos).all.page(params[:page]).per(10).popular
    else
      @posts = Post.includes(:photos).all.page(params[:page]).per(10).order(created_at: :DESC).order(created_at: :DESC)
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_tag = @post.tags
  end

  def edit
    @post = Post.includes(:photos).find(params[:id])
    @post.photos.each do |photo|
      photo.image.cache!
    end
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.includes(:photos).find(params[:id])
    @tag_list = params[:post][:name].split(',')
    if @post.update(post_params)
      # 更新時にタグを削除した場合の処理
      @old_relations = PostTag.where(post_id: @post.id)
      @old_relations.each do |relation|
        relation.delete
      end
      @post.save_tag(@tag_list)
      redirect_to admin_post_path(@post.id), notice: '投稿が更新されました'
    else
      render "edit"
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
