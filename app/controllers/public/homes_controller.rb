class Public::HomesController < ApplicationController
  def top
    @posts = Post.where(status: :published).includes(:photos).limit(3).order(created_at: :DESC)
  end

  def about
  end
end
