class PicturesController < ApplicationController
	def new
    @picture = Picture.new
  end
  def create
    @picture = Picture.new(picture_params)
    @picture.user = current_user
    respond_to do |format|
      if @picture.save
        sync_new @picture
        format.js
      else
        format.js
      end
    end
  end

  private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:image, :user_id,:post_id)
    end
end
