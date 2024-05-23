class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]

    if @model == "user"
      user = User.search_for(@content)
      @records = user.page(params[:page]).per(10)
    else
      post = Post.search_for(@content)
      if params[:latest]
        @records = post.page(params[:page]).per(10).latest
      elsif params[:old]
        @records = post.page(params[:page]).per(10).old
      elsif params[:popular]
        @records = post.page(params[:page]).per(10).popular
      else
        @records = post.page(params[:page]).per(10).order(created_at: :DESC)
      end
    end
  end
end
