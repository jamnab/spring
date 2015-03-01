class PagesController < ApplicationController
  before_action :check_login, only: [:pending_approval, :dashboard, :summary, :search, :archive, :newsfeed]
  before_action :set_organization, only: [:pending_approval, :dashboard, :summary, :search, :archive, :newsfeed]
  before_action :check_org_activation, only: [:dashboard, :summary, :search, :archive, :newsfeed]

  @@page_limit = 10

  def home
    if current_user
      redirect_to :dashboard and return
    end
    render layout: "homepage"
  end

  def price
    render layout: "homepage"
  end

  def contact_us
    render layout: "homepage"
  end

  #used to load pics for the main bord
  def load_pictures

    @picture = Picture.find(params[:pic_id])
    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def dashboard
    @page = params[:page]
    @page = "dashboard" if !params[:page]
    @sort = params[:sort]
    @query = params[:query]

    if current_user.is_admin?

      if @page == "my_fav"
        @posts = current_user.fav_posts
      elsif @page == "archive"
        @posts = Post.where(graveyard: true)
      else
        @posts = Post.where(graveyard: false)
      end

    else

      if @page == "my_fav"
        @posts = current_user.fav_posts
      elsif @page == "archive"
         @posts = current_organization.posts.where(graveyard: true)
      else
        @posts = current_organization.posts.where(graveyard: false)
      end

    end

    if params[:sort] != nil
      if @sort == "newest"
        @posts = @posts.order("created_at DESC")
      elsif @sort == "discussed"
        @posts = @posts.order("comments_count DESC")
      elsif @sort == "upvoted"
        @posts = @posts.order("opinion DESC")
      else
        @posts = @posts.order("created_at DESC")
      end
    else
      @posts = @posts.order(created_at: :desc)
    end

    if params[:query].present?
      if @query == 'doit'
        @posts = @posts.reject{|r| r.doit? == false }
      else
        @posts = @posts.where(:post_type => params[:query])
      end
    end

    if @page == 'doit'
      @posts = @posts.reject{|r| r.doit? == false }
    end

    if params[:populate_disucssion_id].present?
      @populate = true
      @id = params[:populate_disucssion_id].to_i
      @post = Post.find(@id)
    else
      @populate = false
      @post = @posts.first
    end

    if params[:page_num] != nil
      @total_pages =  ((@posts.count.to_f)/@@page_limit.to_f).ceil
      offset = (params[:page_num].to_i - 1) * @@page_limit
      @posts = @posts.slice(offset, @@page_limit)
      # @posts = @posts.limit(@@page_limit).offset(((params[:page_num].to_i - 1) * @@page_limit))
      @page_num = params[:page_num].to_i + 1
      @next_page = true
    else
      @posts = @posts.slice(0, @@page_limit)
      # @posts = @posts.limit(@@page_limit)
      @page_num = 2
    end

    @page_title = 'Post Listing'
    @page_title = 'Doit Aciton Items' if @page == 'doit'
    @page_title = 'Favourited Posts' if @page == 'my_fav'
    @page_title = 'Archived Posts' if @page == 'archive'

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def search
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
    @users = @organization.users
    @sorted_users = @users.sort_by{|x| -(x.contribution['total']+x.impact['positive'])}
  end

  def pending_approval
  end

  def newsfeed
    @posts = @organization.posts.where(graveyard: false)
    @posts = @posts.reject{|r| r.doit? == false }

    @users = @organization.users
    @sorted_users_by_post_type = {
      Post::PROJECT => @users.sort_by{|x| -x.performance_by_post_type(Post::PROJECT)['performance']},
      Post::FUN => @users.sort_by{|x| -x.performance_by_post_type(Post::FUN)['performance']},
      Post::FACILITY => @users.sort_by{|x| -x.performance_by_post_type(Post::FACILITY)['performance']},
    }
  end

  private
    def check_login
      if current_user.nil?
        redirect_to :root and return
      end
    end

    def set_organization
      @organization = current_organization
      @organization = Organization.first if current_user.is_admin?
    end

    def check_org_activation
      if !@organization.activated
        redirect_to :pending_approval and return
      end
    end
end
