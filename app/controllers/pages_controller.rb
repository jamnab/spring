class PagesController < ApplicationController
  before_action :check_login, only: [:dashboard, :summary, :search, :archive]

  def home
  end

  def dashboard
    if current_user.is_admin?
      @posts = Post.where(graveyard: false)
    else
      @posts = current_organization.posts.where(graveyard: false)
    end
  end

  def my_favourites
    @posts = current_user.fav_posts
  end

  def archive
    if current_user.is_admin?
      @posts = Post.where(graveyard: true)
    else
      @posts = current_organization.posts.where(graveyard: true)
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
    @organization = current_organization

    @organization = Organization.first if current_user.is_admin?
  end

  private
    def check_login
      if current_user.nil?
        redirect_to :root and return
      end
    end
end
