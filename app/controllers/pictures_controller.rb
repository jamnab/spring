class PicturesController < ApplicationController
	def new
    @picture = Picture.new
  end
  def create
    raise
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

  def destroy
    @picture = Picture.find(params[:id])
    @post = @picture.post
    @id = @picture.id
    @picture.destroy
    respond_to do |format|
      sync_update @post
      format.js
    end
  end
  private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:image, :user_id,:post_id,:organization_id)
    end
end
