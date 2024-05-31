class Public::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :edit, :update, :destory, :search_tag]
  before_action :check_guest_user, only: [:new, :edit]
  before_action :ensure_correct_user, only: [:edit]

  def new
    @post = Post.new
    @post.photos.build
  end

  def create
    @post = Post.new(post_params)
    @tag_list = params[:post][:name].split(',')
    if @post.save
      @post.save_tag(@tag_list)
      redirect_to post_path(@post.id)
    else
      render "new"
    end
  end

  def index
    @tag_list = Tag.limit(5).popular

    if params[:latest]
      @posts = Post.includes(:photos).page(params[:page]).per(8).latest
    elsif params[:old]
      @posts = Post.includes(:photos).page(params[:page]).per(8).old
    elsif params[:popular]
      @posts = Post.includes(:photos).page(params[:page]).per(8).popular
    else
      @posts = Post.includes(:photos).all.page(params[:page]).per(8).order(created_at: :DESC)
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment = PostComment.new
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
      redirect_to post_path(@post.id), notice: '投稿が更新されました'
    else
      render "edit"
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def search_tag
    @tag_list = Tag.limit(5).popular
    @tag = Tag.find(params[:tag_id])
    if params[:latest]
      @posts = @tag.posts.page(params[:page]).per(8).latest
    elsif params[:old]
      @posts = @tag.posts.page(params[:page]).per(8).old
    elsif params[:popular]
      @posts = @tag.posts.page(params[:page]).per(8).popular
    else
      @posts = @tag.posts.page(params[:page]).per(8).order(created_at: :DESC)
    end
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
