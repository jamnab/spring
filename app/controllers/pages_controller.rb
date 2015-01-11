class PagesController < ApplicationController
  def home
  end

  def dashboard
    if current_user.is_admin?
     	if params[:query].present?
        @p = params[:query]
        if @p == "doit"
          @posts=Post.all.reject{|r| r.doit? == false }
        else
          @posts = Post.where(:post_type => params[:query])
        end
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
    else
      if params[:query].present?
        @p = params[:query]
        @posts = current_organization.posts.where(:post_type => params[:query])
      elsif params[:sort].present?
        @p = params[:sort]
        if @p == "newest"
          @posts = current_organization.posts.all.order("created_at DESC")
        elsif @p == "discussed"

        else
          @posts = current_organization.posts.all.order("traction DESC")
        end
      else
        @posts = current_organization.posts.all.order("created_at DESC")
      end
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
