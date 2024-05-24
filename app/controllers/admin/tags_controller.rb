class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @tags = Tag.all.page(params[:page]).per(10).order(created_at: :ASC)
  end

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    redirect_to request.referer, notice: "タグを削除しました"
  end
end
