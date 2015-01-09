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

  def verse
    render layout: false
  end
end
