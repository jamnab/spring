class PagesController < ApplicationController
  def home
  end

  def dashboard
   	if params[:query].present?
      @p = params[:query]
      @posts = Post.where(:post_type => params[:query])
    elsif params[:sort].present?
      @p = params[:sort]
      if @p == "newest"
        @posts = Post.all.order("created_at DESC")
      elsif @p == "discussed"

      else
        @posts = Post.all.order("traction DESC")
      end
    else
      @posts = Post.all.order("created_at DESC")
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end

  end
  def search
  	if params[:query].present?
      @posts = Post.search(params[:query])
    else
      @posts = Post.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end
  def verse
    render layout: false
  end
end
