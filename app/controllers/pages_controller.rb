class PagesController < ApplicationController
  def home
  end

  def dashboard 
    if current_user.is_admin?
      @posts = Post.all
    else
      @posts = current_organization.posts
    end



   	if params[:query].present?
      @p = params[:query]
      if @p == "doit"
        @posts.reject!{|r| r.doit? == false }
      else
        @posts = @posts.where(:post_type => params[:query])
      end
    elsif params[:sort].present?
      @p = params[:sort]
      if @p == "newest"
        @posts = @posts.order("created_at DESC")
      elsif @p == "discussed"

      else
        @posts = @posts.order("traction DESC")
      end
    else
      @posts = @posts.order("created_at DESC")
    end
   


    if params[:populate_disucssion_id].present?
      @populate = true
      @id = params[:populate_disucssion_id].to_i
      @post = Post.find(@id)
    else
      @populate = false
      @post = @posts.first
    end 


    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def search
  	if params[:query].present?
      @posts = current_organization.posts.search(params[:query])
    else
      @posts = current_organization.posts.all
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
