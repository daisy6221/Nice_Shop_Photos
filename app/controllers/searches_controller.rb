class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @tag = params[:tag]

    if @model == "user"
      user = User.search_for(@content)
      @records = user.page(params[:page]).per(8)
    else
      post = Post.search_for(@content, @tag)
      if params[:latest]
        @records = post.page(params[:page]).per(8).latest
      elsif params[:old]
        @records = post.page(params[:page]).per(8).old
      elsif params[:popular]
        @records = post.page(params[:page]).per(8).popular
      else
        @records = post.page(params[:page]).per(8).order(created_at: :DESC)
      end
    end
  end
end
