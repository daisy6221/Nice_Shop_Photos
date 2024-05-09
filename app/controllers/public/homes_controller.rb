class Public::HomesController < ApplicationController
  def top
    @posts = Post.limit(5).order(created_at: :DESC)
  end

  def about
  end
end
