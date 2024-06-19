class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = @post.id
    unless @comment.save
      render 'error'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = PostComment.find_by(id: params[:id], post_id: params[:post_id])
    @comment.destroy
  end

  private

  def check_guest_user
    if current_user.guest?
      redirect_to root_path, alert: "コメントをする場合は会員登録を行ってください"
    end
  end

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end
