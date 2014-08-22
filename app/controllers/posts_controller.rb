class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  include ProjectsHelper

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    if params[:comment_order] == 'newest'
      @comments = @post.comments.order(created_at: :desc)
    elsif params[:comment_order] == 'upvote'
      @comments = @post.comments.sort_by{|x| count_opinion(x.opinions)}
    elsif params[:comment_order] == 'happiness'
      # SHOULD store sentiment as a field upon save
      # @comments = @post.comments.sort_by{|x| JSON.parse(Sentimentalizer.analyze(x.content).to_json). }
    elsif params[:comment_order] == 'distress'
    else
      @comments = @post.comments
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    sentiment_update(@post)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post.project, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        sentiment_update(@post)

        format.html { redirect_to @post.project, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @project = @post.project
    @post.destroy
    respond_to do |format|
      format.html { redirect_to @project, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
      @project = @post.project
      @organization = @project.organization
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :endorsed, :anonymous, :threshold, :user_id, :project_id, :comment_anonymity)
    end
end
