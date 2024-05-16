class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_guest_user

  def create
    post = Post.find(params[:post_id])
    @comment = current_user.post_comments.new(post_comment_params)
    @comment.post_id = post.id
    if @comment.save
      redirect_to request.referer, notice: "コメントを投稿しました"
    else
      redirect_to request.referer, alert: "コメントが空欄です"
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to request.referer, notice: "コメントを削除しました"
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
