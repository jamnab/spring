class PagesController < ApplicationController
  def home
  end

  def dashboard
   	 @posts = Post.all
  end
  def search
  	if params[:query].present?
      @posts = Post.search(params[:query])
    else
      @posts = Post.all
    end

    respond_to do |format|
    	sync_update @posts
      format.html # index.html.erb
      format.js
    end
  end
  def verse
    render layout: false
  end
end
