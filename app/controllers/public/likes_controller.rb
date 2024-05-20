class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user

  def create
    @post = Post.find(params[:post_id])
    like = current_user.likes.new(post_id: @post.id)
    like.save
  end

  def destroy
　  @post = Post.find(params[:post_id])
　  like = current_user.likes.find_by(post_id: @post.id)
　  like.destroy
  end

  private

  def check_guest_user
    if current_user.guest?
      redirect_to root_path, alert: "いいねをする場合は会員登録を行ってください"
    end
  end
end
