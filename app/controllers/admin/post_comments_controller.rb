class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to request.referer, notice: "コメントを削除しました"
  end

end
