class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!

  def index
    if params[:latest]
      @posts = Post.admin.includes(:photos).page(params[:page]).per(8).latest
    elsif params[:old]
      @posts = Post.admin.includes(:photos).page(params[:page]).per(8).old
    elsif params[:popular]
      @posts = Post.admin.includes(:photos).page(params[:page]).per(8).popular
    else
      @posts = Post.admin.includes(:photos).page(params[:page]).per(8).order(created_at: :DESC)
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    if @post.status == "draft"
      redirect_to admin_posts_path, alert: "ユーザーが下書きに指定しているため、管理者側で閲覧できません"
    end
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
      if params[:post][:status] == "unpublished"
        redirect_to admin_posts_path, notice: '投稿を非公開に設定しました'
      else
        @post.update_tag(@tag_list)
        redirect_to admin_post_path(@post.id), notice: '投稿が更新されました'
      end
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
    params.require(:post).permit(:title, :shop_name, :address, :body, :status, photos_attributes: [:id, :_destroy, :image, :image_cache])
  end
end
