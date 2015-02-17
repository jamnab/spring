class ApplicationController < ActionController::Base
  protect_from_forgery

  # require "sentimentalizer"

  helper_method :current_user
  helper_method :current_organization

  private

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
