class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  helper_method :current_user
  helper_method :current_organization
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
