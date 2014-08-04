class TagEntriesController < ApplicationController
  before_action :set_tag_entry, only: [:destroy]

  # POST /tag_entries
  # POST /tag_entries.json
  def create
    @tag_entry = TagEntry.new(tag_entry_params)
    @tag = Tag.where(name: params[:name], project_id: params[:project_id]).first
    if @tag.nil?
      @tag = Tag.create(name: params[:name], project_id: params[:project_id])
    end
    @tag_entry.tag = @tag

    respond_to do |format|
      if @tag_entry.save
        format.html { redirect_to @tag_entry.taggable, notice: 'Tag entry was successfully created.' }
        format.json { render :show, status: :created, location: @tag_entry }
      else
        format.html { render :new }
        format.json { render json: @tag_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tag_entries/1
  # DELETE /tag_entries/1.json
  def destroy
    @taggable = @tag_entry.taggable
    @tag_entry.destroy
    respond_to do |format|
      format.html { redirect_to @taggable, notice: 'Tag entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag_entry
      @tag_entry = TagEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_entry_params
      params.require(:tag_entry).permit(:tag_id, :taggable_id, :taggable_type)
    end
end
