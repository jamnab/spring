class OpinionsController < ApplicationController
  before_action :set_opinion, only: [:destroy]

  # POST /opinions
  # POST /opinions.json
  def create
    @opinion = Opinion.where(opinionable_id: opinion_params[:opinionable_id], opinionable_type: opinion_params[:opinionable_type], user_id: current_user.id).first

    # if existing, just tweak
    if @opinion.nil?
      @opinion = Opinion.new(opinion_params)
      @opinionable = @opinion.opinionable
      # new opinion, value change by 1
      if @opinion.positive
        @opinionable.opinion += 1
      else
        @opinionable.opinion -= 1
      end
    else
      # old opinion, remove or value change 2
      @opinionable = @opinion.opinionable
      if @opinion.positive.to_s == opinion_params[:positive]
        # remove
        if @opinion.positive
          @opinionable.opinion -= 1
        else
          @opinionable.opinion += 1
        end
        @opinion.destroy
        @opinionable.save
        sync_update @opinion.opinionable
        sync_update @opinion.opinionable.commentable if @opinion.opinionable.class.to_s == 'Comment'
        # redirect_to @opinion.opinionable and return
      else
        @opinion.positive = opinion_params[:positive]
        if @opinion.positive
          @opinionable.opinion += 2
        else
          @opinionable.opinion -= 2
        end
      end
    end

    respond_to do |format|
      if @opinion.save && @opinionable.save
        if @opinion.opinionable.class.to_s == 'Post'
          @opinion.opinionable.update_launched_status
          sync_destroy @opinion.opinionable
        end
        sync_update @opinion.opinionable.commentable if @opinion.opinionable.class.to_s == 'Comment'
        format.html { redirect_to @opinion.opinionable, notice: 'Opinion was successfully created.' }
        format.json { render action: 'show', status: :created, location: @opinion }
      else
        format.html { render action: 'new' }
        format.json { render json: @opinion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /opinions/1
  # DELETE /opinions/1.json
  def destroy
    @opinionable = @opinion.opinionable
    @opinion.destroy
    if @opinionable.class.to_s == "Comment"
      @opinion.opinionable = @opinionable.commentable
    else
      @opinion.opinionable = @opinionable
    end
    respond_to do |format|
      format.html { redirect_to @opinion.opinionable }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opinion
      @opinion = Opinion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def opinion_params
      params.require(:opinion).permit(:positive, :opinionable_id, :opinionable_type, :user_id)
    end
end
