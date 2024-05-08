class Public::PostsController < ApplicationController
  def new
    @post = Post.new
    @post.photos.build()
  end

  def create
    @post = Post.new(post_params)
    if @post.save!
       params[:post_photos][:image].each do |image|
         @post.photos.create(image: image, post_id: @post.id)
       end
      redirect_to root_path
    else
      flash[:notice] = "投稿に失敗しました"
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def post_params
    params.require(:post).permit(:title, :shop_name, :address, :body, photos_attributes: [:image])
  end
end
