class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy, :my_organization]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def my_organization
    if current_organization
      redirect_to current_organization and return
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @organization = Organization.where(name: @user.organization_name).first
    @invites = UserInvite.where(email: @user.email)
    new_org = false

    # allow if new organization or has embedded token
    if @user.is_manager? && @organization.nil?
      # create new organization
      new_org = true
    elsif @user.is_manager? && !@organization.nil?
      redirect_to :back, notice: "Error: Cannot create an organization that already exists." and return
    elsif !@user.is_manager? && @organization.nil?
      redirect_to :back, notice: "Error: Cannot join, organization does not exist." and return
    else
      # check for invite
      if !@invites.empty?
        # joins existing organization
        @user.organization_id = @organization.id
      else
        redirect_to :back, notice: "Error: Cannot join, there are no invites associated with this email address." and return
      end
    end

    respond_to do |format|
      if @user.save
        if new_org
          @organization = Organization.create(name: @user.organization_name)
          @user.update(organization_id: @organization.id)
        end
        @invites.each do |invite|
          # join department, remove invite
          DepartmentEntryMembership.create(user: @user, department_entry: invite.department_entry, admin: invite.admin)
          invite.destroy
        end
        format.html { redirect_to :dashboard, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to :back, notice: 'Failed to register, invalid information.' }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    params[:user][:manager] = @user.manager
    if params[:user][:pictures] != nil
      @pic = Picture.new
      @pic.image = params[:user][:pictures][:image]
      if @pic.save
        @user.picture = @pic
        @user.save
      end
    end
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to :back, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :first_name, :last_name, :organization_name, :organization_token, :job_title, :manager, :organization_id, :subscribe_to_newsletter)
    end
end
