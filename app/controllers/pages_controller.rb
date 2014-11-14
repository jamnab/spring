class PagesController < ApplicationController
  def home
  end

  def dashboard
  end

  def verse
    render layout: false
  end
end
