class PagesController < ApplicationController
  def home
  end

  def verse
    render layout: false
  end
end
