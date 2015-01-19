class CommentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    @comment
    respond_to do|format|
      format.js
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        sync_new @comment
        if @comment.commentable_type == "Post"
        @post = @comment.commentable
        end
        format.html { redirect_to @comment.commentable, notice:  'Comment was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        @post = @comment.commentable
        sync_update @post
        sync_update @comment
        format.html { redirect_to @comment.commentable, notice: 'Comment was successfully updated.' }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @commentable = @comment.commentable
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @commentable, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :endorsed, :anonymous, :commentable_id, :commentable_type, :user_id)
    end
end
