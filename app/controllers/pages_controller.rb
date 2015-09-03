class PagesController < ApplicationController
  before_action :check_login, only: [:pending_approval, :dashboard, :summary, :search, :archive, :newsfeed]
  before_action :set_organization, only: [:pending_approval, :dashboard, :summary, :search, :archive, :newsfeed]
  before_action :check_org_activation, only: [:dashboard, :summary, :search, :archive, :newsfeed]

  @@global_limit = 200
  @@page_limit = 200

  require 'csv'

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
    @filter = params[:filter]
    @query = params[:query]
    @viewmode = params[:viewmode]

    if @page == "following"
      @posts = current_organization_posts(@filter)[:following_posts]
    elsif @page == 'pending'
      @posts = current_organization_posts(@filter)[:pending_posts]
    elsif @page == "archive"
      @posts = @organization.posts.where(graveyard: true)
    else
      @posts = current_organization_posts(@filter)[:approved_posts]
    end

    # AR -> Array drity filters
    current_organization_posts(@filter)[:launched_posts] = current_organization_posts(@filter)[:approved_posts].reject{|r| r.doit? == false }
    current_organization_posts(@filter)[:idea_posts] = current_organization_posts(@filter)[:approved_posts].reject{|r| (r.doit? == true) || (Opinion.where(opinionable: r, user: current_user).count > 0) }
    # if ideas overall, filter out voted and launched items

    # if params[:sort] != nil
    #   if @sort == "newest"
    #     @posts = @posts.order("created_at DESC")
    #   elsif @sort == "discussed"
    #     @posts = @posts.order("comments_count DESC")
    #   elsif @sort == "upvoted"
    #     @posts = @posts.order("opinion DESC")
    #   else
    #     @posts = @posts.order("created_at DESC")
    #   end
    # else
    #   @posts = @posts.order(created_at: :desc)
    # end

    if @page == 'doit'
      @posts = current_organization_posts(@filter)[:launched_posts]
    elsif @page == 'dashboard'
      @posts = current_organization_posts(@filter)[:idea_posts]
    end

    if params[:populate_disucssion_id].present?
      @populate = true
      @id = params[:populate_disucssion_id].to_i
      @post = Post.find(@id)
    else
      @populate = false
      @post = @posts.first
    end

    # if params[:page_num] != nil
    #   @total_pages =  ((@posts.count.to_f)/@@page_limit.to_f).ceil
    #   offset = (params[:page_num].to_i - 1) * @@page_limit
    #   @posts = @posts.slice(offset, @@page_limit)
    #   # @posts = @posts.limit(@@page_limit).offset(((params[:page_num].to_i - 1) * @@page_limit))
    #   @page_num = params[:page_num].to_i + 1
    #   @next_page = true
    # else
    #   @posts = @posts.slice(0, @@page_limit)
    #   # @posts = @posts.limit(@@page_limit)
    #   @page_num = 2
    # end

    @page_title = 'Idea Board'
    @page_title = 'Launch Action Items' if @page == 'doit'
    @page_title = 'Pending Posts' if @page == 'pending'
    @page_title = 'Following Posts' if @page == 'following'
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

    @post = @posts.first

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  def summary
    if !current_user.is_manager?
      redirect_to :back, notice: "No permission" and return
    end

    # contributions_by_department_csv = File.read('public/dummy_data/contributions_by_department.csv')
    # @contributions_by_department = CSV.parse(contributions_by_department_csv, :headers => true)
    @contributions_by_department = []
    current_organization.department_entries.each do |de|
      entry = {
        'Department' => de.department_name,
        '# Ideas Actionable' => de.posts.where(launch_approved: true).count,
        '# Ideas Total' => de.posts.count,
        '# Ideas Approved' => de.posts.where(approved: true).count,
        '# of Comments' => de.comments.count,
        '# of Votes' => de.opinions.count,
        '# of Users' => de.users.count
      }
      @contributions_by_department.push(entry)
    end
    @contributions_by_department = @contributions_by_department.sort_by{|x| -x['# Ideas Actionable'].to_i}

    # contributions_by_employee_csv = File.read('public/dummy_data/contributions_by_employee.csv')
    # @contributions_by_employee = CSV.parse(contributions_by_employee_csv, :headers => true)
    @contributions_by_employee = []
    current_organization.users.uniq.each do |user|
      entry = {
        'Name' => user.full_name,
        '# Ideas Actionable' => user.posts.where(launch_approved: true).count,
        '# Ideas Total' => user.posts.count,
        '# Ideas Approved' => user.posts.where(approved: true).count,
        '# of Comments Received' => user.posts.sum(:comments_count),
        '# of Comments Given' => user.comments.count,
        '# of Votes Received' => user.posts.map{|x| x.opinions.count}.inject(0, :+),
        '# of Votes Given' => user.opinions.count,
        'user_id' => user.id
      }
      @contributions_by_employee.push(entry)
    end
    @contributions_by_employee = @contributions_by_employee.sort_by{|x| -x['# Ideas Actionable'].to_i}

    # trending_ideas_csv = File.read('public/dummy_data/trending_ideas.csv')
    # @trending_ideas = CSV.parse(trending_ideas_csv, :headers => true)
    @trending_ideas = []
    current_organization.posts.where(approved: true, launch_approved: false).each do |post|
      audience_size = post.department_entries.map{|x| x.users.count}.inject(0, :+)
      entry = {
        'Label' => post.user.full_name,
        'Title' => post.title,
        'Support' => post.opinions.where(positive: true).count * 100 / audience_size,
        '# of Comments' => post.comments.count,
        '# of Votes' => post.opinions.count,
        'Poster' => post.user.full_name
      }
      @trending_ideas.push(entry)
    end
    @trending_ideas = @trending_ideas.sort_by{|x| -x['Support'].to_i}

    # approved_ideas_csv = File.read('public/dummy_data/approved_ideas.csv')
    # @approved_ideas = CSV.parse(approved_ideas_csv, :headers => true)
    @approved_ideas = []
    current_organization.posts.where(launch_approved: true).each do |post|
      audience_size = post.department_entries.map{|x| x.users.count}.inject(0, :+)
      entry = {
        'Label' => post.user.full_name,
        'Title' => post.title,
        'Support' => post.opinions.where(positive: true).count * 100 / audience_size,
        '# of Comments' => post.comments.count,
        '# of Votes' => post.opinions.count,
        'Poster' => post.user.full_name
      }
      @approved_ideas.push(entry)
    end
    @approved_ideas = @approved_ideas.sort_by{|x| -x['Support'].to_i}

    detailed_trends_csv = File.read("#{Rails.root}/public/dummy_data/detailed_trends.csv")
    @detailed_trends = CSV.parse(detailed_trends_csv, :headers => true)
    @stat_overview = {
      num_actionables: current_organization.posts.where(launch_approved: true).count,
      num_total_ideas: current_organization.posts.count,
      num_approved: current_organization.posts.where(launch_approved: false, approved: true).count,
      num_comments: current_organization.posts.sum(:comments_count),
      num_votes: current_organization.posts.map{|x| x.opinions.count}.inject(0, :+),
      num_users: current_organization.users.uniq.count
    }
    # @detailed_trends = [['Date', '# Ideas Actionable', '# Ideas Total', '# Ideas Approved']]
    # 7.times do |i|
    #   date = Date.today - i.days
    #   posts = current_organization.posts.where(created_at: date .. date + 1.day)
    #   entry = []
    #   entry.push(date.strftime('%m/%d/%Y'))
    #   entry.push(posts.where(launch_approved: true).count)
    #   entry.push(posts.count)
    #   entry.push(posts.where(launch_approved: false, approved: true).count)
    #   @detailed_trends.push(entry)
    # end

    respond_to do |format|
      format.html
      format.json
    end
  end

  def pending_approval
  end

  def newsfeed
    @viewmode = 'list'
    @posts = @organization.posts.where(graveyard: false)
    @posts = @posts.reject{|r| r.doit? == false }

    @users = @organization.users
    # TYPE REPLACED WITH DEPARTMENTS
    # @sorted_users_by_post_type = {
    #   Post::PROJECT => @users.sort_by{|x| -x.performance_by_post_type(Post::PROJECT)['performance']},
    #   Post::FUN => @users.sort_by{|x| -x.performance_by_post_type(Post::FUN)['performance']},
    #   Post::FACILITY => @users.sort_by{|x| -x.performance_by_post_type(Post::FACILITY)['performance']},
    # }
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
