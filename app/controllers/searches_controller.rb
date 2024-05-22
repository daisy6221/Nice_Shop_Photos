class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]

    if @model == "user"
      user = User.search_for(@content)
      @records = user.page(params[:page]).per(10)
    else
      post = Post.search_for(@content)
      @records = post.page(params[:page]).per(10)
    # else
    #   tag = Tag.search_for(@content)
    #   @records = tag.page(params[:page]).per(10)
    end
  end
end
