class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :set_post, only: [:show, :edit, :update, :judge, :destroy]
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
    respond_to do |format|
      format.js
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        @activity = PublicActivity::Activity.create(owner: current_user,
          key: 'Post.made_a_new', trackable:@post)
        if @activity.id != nil
          sync_new @activity
        end
        current_user.organization.users.uniq.each do |u|
          Notification.create(user: u, activity: @activity)
          sync_new @activity, scope: u
        end
        # @msg = "Your post was created successfully"
        # @class = "success"
        flash[:success] ="Your post was created successfully"
        @post.update(organization: current_organization)
        if params[:images]
          params[:images].each { |image|
            @post.pictures.create(image: image)
          }
        end
        if !params[:departments].nil?
          params[:departments].each do |de_id|
            PostDepartmentEntry.create(post: @post, department_entry_id: de_id)
          end
        end
        sync_new @post, scope: current_organization
        sync_new @post
        if current_user.is_admin?
          @posts = Post.all
        else
          @posts = current_organization.posts
        end
        format.js
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if !params[:images].nil?
      params[:images].each { |image|
        @post.pictures.create(image: image)
      }
    end
    @viewmode = params[:viewmode]
    respond_to do |format|
      if @post.update(post_params)
        @activity = PublicActivity::Activity.create(owner: current_user,
          key: 'Post.edited_a', trackable:@post)
        if @activity.id != nil
          sync_new @activity
        end
        current_user.organization.users.uniq.each do |u|
          Notification.create(user: u, activity: @activity)
          sync_new @activity, scope:u
        end
        if !params[:departments].nil?
          @post.post_department_entries.each{|x| x.destroy}
          params[:departments].each do |de_id|
            PostDepartmentEntry.create(post: @post, department_entry_id: de_id)
          end
        end
        sync_update @post
        format.html { redirect_to :dashboard, notice: 'Post was successfully updated.' }
        format.js
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def judge
    @url = Rails.env.production? ? request.host : request.host_with_port
    @viewmode = params[:viewmode]

    # listing approval
    if !params[:approved].nil?
      if params[:approved]
        @post.update(approved: true)
      else
        @post.update(graveyard: true)
      end
      Notifier.post_update(@post, @url).deliver!
    end

    # launch approval
    if !params[:launch_approved].nil?
      @post.update(launch_approved: params[:launch_approved])
      if !params[:action_date].nil?
        @post.update(action_date: params[:action_date])
      end
      Notifier.post_update(@post, @url).deliver!
    end

    # TODO: need to generate activity and notification
    respond_to do |format|
      sync_update @post
      format.html { redirect_to :dashboard, notice: 'Post was successfully updated.' }
      format.js { render action: "update" }
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @organization = @post.organization
    @post.destroy
    respond_to do |format|
      sync_destroy(@post)
      format.html { redirect_to @organization, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
      @organization = @post.organization
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content, :post_type, :endorsed, :anonymous, :threshold, :user_id, :comment_anonymity, :pictures, :graveyard)
    end
end
