class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  helper_method :current_user
  helper_method :current_organization
  helper_method :current_organization_posts
  helper_method :current_organization_posts_counts
  helper_method :current_departments
  helper_method :current_department_entries

  private

  def current_departments
    current_department_entries.map{|x| x.name}
  end

  def current_department_entries
    if current_user.is_manager?
      current_organization.department_entries
    else
      current_user.department_entries
    end
  end

  def current_organization
    if current_user.is_admin?
      @organization = Organization.first
    else
      current_user.organization
    end
  end

  def current_organization_posts(query = nil)
    if current_user.is_admin?
      # user is super admin, use first org as sample
      @organization = Organization.first
    else
      @organization = current_organization
    end

    if can? :update, @organization
      @pending_posts = @organization.posts.where(approved: false, graveyard: false)
    else
      @pending_posts = @organization.posts.where(user: current_user, approved: false, graveyard: false)
    end

    # silo posts of this organization
    @approved_posts = @organization.posts.where(approved: true, graveyard: false)
    @following_posts = @organization.posts.joins(:opinions).where(opinions: {positive: true, user: current_user})

    # apply category filter
    if !query.nil? && query != 'doit'
      department_id = query
      @approved_posts = @approved_posts.joins(:department_entries).where(department_entries: {id: department_id})
      @following_posts = @following_posts.joins(:department_entries).where(department_entries: {id: department_id})
    end

    # AR -> Array drity filters
    @launched_posts = @approved_posts.reject{|r| r.doit? == false }
    @idea_posts = @approved_posts.reject{|r| (r.doit? == true) || (Opinion.where(opinionable: r, user: current_user).count > 0) }
    # if ideas overall, filter out voted and launched items

    return {approved_posts: @approved_posts, idea_posts: @idea_posts, pending_posts: @pending_posts,
      following_posts: @following_posts, launched_posts: @launched_posts}
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  # def sentiment_update(sentimentable)
  #   sentiment_res = JSON.parse(Sentimentalizer.analyze(sentimentable.content).to_json)
  #   if sentiment_res['sentiment'].nil?
  #     sentimentable.sentiment_category = nil
  #     sentimentable.sentiment_percentage = nil
  #   else
  #     if sentiment_res['sentiment'] == ':)'
  #       sentimentable.sentiment_category = 1
  #     elsif sentiment_res['sentiment'] == ':('
  #       sentimentable.sentiment_category = -1
  #     else
  #       sentimentable.sentiment_category = 0
  #     end
  #     sentimentable.sentiment_percentage = (sentiment_res['probability'] * 100).to_i
  #   end
  #   sentimentable.save
  # end
end
