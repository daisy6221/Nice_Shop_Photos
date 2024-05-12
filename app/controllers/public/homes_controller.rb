class Public::HomesController < ApplicationController
  def top
    @posts = Post.includes(:photos).limit(5).order(created_at: :DESC)
  end

  def about
  end
end
