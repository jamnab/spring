class PagesController < ApplicationController
  before_action :check_login, only: [:dashboard, :summary, :search, :archive]

  def home
  end

  def dashboard
    if current_user.is_admin?
        if params[:query].present?
        @query = params[:query]
        if @query == "doit"
          @posts = Post.all.reject{|r| r.doit? == false }
        else
          @posts = Post.where(:post_type => params[:query])
        end
      elsif params[:sort].present?
        @query = params[:sort]
        if @query == "newest"
          @posts = Post.all.order("created_at DESC")
        elsif @query == "discussed"

        else
          @posts = Post.all.order("traction DESC")
        end
      else
        @posts = Post.all.order("created_at DESC")
      end
    else
      if params[:query].present?
        @query = params[:query]
        @posts = current_organization.posts.where(:post_type => params[:query])
      elsif params[:sort].present?
        @query = params[:sort]
        if @query == "newest"
          @posts = current_organization.posts.all.order("created_at DESC")
        elsif
          @query == "discussed"
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
      @posts = current_organization.posts.search(params[:query])
    else
      @posts = current_organization.posts.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def summary
    # if current_user.is_manager?
    #   redirect_to :back, notice: "No permission" and return
    # end

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
