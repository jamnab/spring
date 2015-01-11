class PagesController < ApplicationController
  def home
  end

  def dashboard
    if current_user.is_admin?
      @posts = Post.all
    else
      @posts = current_organization.posts
    end
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

  def summary
    @users = User.all
  end
end
