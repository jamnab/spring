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

  def filter_sort
    @post = Post.find(params[:post_id])
    @comments = @post.comments
    @filter = params[:filter]
    @sort = params[:sort]
    @sort = "newest" if @sort == nil
    @filter = "all" if @filter == nil
    @comments_page_num = params[:comments_page_num]
    if @filter == "plain"
      @comments = @comments.where(:suggestion => false)
    elsif @filter =='suggestion'
      @comments = @comments.where(:suggestion => true)
    end
    if @sort == "newest"
      @comments = @comments.order(created_at: :desc)
    elsif @sort =="upvoted"
      @comments = @comments.order(opinion: :desc)
    end
    if params[:comments_page_num] != nil

      @comments = @comments.limit(4).offset((@comments_page_num.to_i)*(4))
    end
    respond_to do |format|
      format.js
    end
  end
  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    if params[:suggestion]!= nil
      @comment.suggestion = true
    end
    respond_to do |format|
      if @comment.save

        if @comment.commentable_type == "Post"
          @post = @comment.commentable
          @comments = @post.comments
          sync_new @comment, scope:@post
          sync_update @post
          @activity = PublicActivity::Activity.create(owner: current_user,
            key: 'Comment.commented_on_a', trackable:@comment)
          @u_activity = PublicActivity::Activity.create(owner: current_user,key: 'Comment.commmented_on_your',trackable:@comment)

          @post.comments.each do |c|
            if c.user != @post.user
              @activity.users << c.user
              sync_new @activity, scope:c.user
            end
          end
          @u_activity.users << @post.user
          sync_new @u_activity, scope:@post.user
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
        sync_update @comment
        sync_update @post
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
