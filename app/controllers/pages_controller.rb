class PagesController < ApplicationController
  before_action :check_login, only: [:dashboard, :summary, :search, :archive]

  def home
    if current_user 
      @organization = current_organization
      @organization = Organization.first if current_user.is_admin?
    end
  end

  def dashboard 
    @organization = current_organization
    @organization = Organization.first if current_user.is_admin?
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
        @posts = Post.all
      end

    else

      if @page == "my_fav"
        @posts = current_user.fav_posts
      elsif @page == "archive"
         @posts = current_organization.posts.where(graveyard: true)
      else 
        @posts = current_organization.posts
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
      
      if @query == "doit"
        @posts=@posts.reject{|r| r.doit? == false }
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
    if params[:page_num] != nil
      @posts = @posts.limit(4).offset(((params[:page_num].to_i - 1)*4))
      @page_num = params[:page_num].to_i + 1
      @next_page = true
    else
      @posts = @posts.limit(4)
      @page_num = 2

    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
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
