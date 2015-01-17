class PagesController < ApplicationController
  before_action :check_login, only: [:dashboard, :summary, :search, :archive]

  def home
  end

  def dashboard
    if current_user.is_admin?
      @posts = Post.order(created_at: :desc)
    else
      @posts = current_organization.posts.order(created_at: :desc)
    end

    if params[:sort].present?
      @query = params[:sort]
      if @query == "newest"
        @posts = @posts.reorder(created_at: :desc)
      elsif @query == "discussed"
        @posts = @posts.reorder(comments_count: :desc)
      else
        @posts = @posts.reorder(opinion: :desc)
      end
    end

    if params[:query].present?
      @query = params[:query]
      if @query == "doit"
        @posts = @posts.reject{|r| r.doit? == false }
      elsif @query == "all"
        @posts = @posts.reorder(created_at: :desc)
      else
        @posts = @posts.where(:post_type => params[:query])
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
    @organization = current_organization
    @organization = Organization.first if current_user.is_admin?

    if params[:query].present?
      @posts = @organization.posts.search(params[:query])
    else
      @posts = @organization.posts.all
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

    @organization = current_organization
    @organization = Organization.first if current_user.is_admin?

    @users = @organization.users
    @sorted_users = @users.sort_by{|x| -(x.contribution['total']+x.impact['total'])}
  end

  private
    def check_login
      if current_user.nil?
        redirect_to :root and return
      end
    end
end
