class OrganizationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :generate_code, :toggle]

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.order(:activated)
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
    pics = @organization.build.picture
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    @organization.access_token = ('a'..'z').to_a.shuffle[0,32].join

    respond_to do |format|
      if @organization.save
        OrganizationMembership.create(user_id: current_user.id, organization_id: @organization.id, admin: true)
        params[:departments].each do |d_id|
          DepartmentEntry.create(context: @organization, department_id: d_id)
        end
        format.html { redirect_to :dashboard, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    respond_to do |format|
      if @organization.toggle_activation_status!
        format.html {
          redirect_to :back, notice: 'Organization activation status toggled.'
        }
      else
        format.html {
          flash[:error] = "Could not toggle organization's activation status. Please try again later"
          redirect_to :back
        }
      end
    end
  end

  # def generate_code
  #   @prev = @organization.access_token
  #   @new = ('a'..'z').to_a.shuffle[0,32].join
  #   @organization.update_attribute(:access_token, @new)
  #   @user = current_user
  #   @url = Rails.env.production? ? request.host : request.host_with_port
  #   Notifier.register_form(@user, @organization,@url).deliver_now
  #   @organization.delay(run_at: 1.day.from_now).update_attribute(:access_token, nil)
  #   @time = Time.now
  #   redirect_to :back, notice: 'New access code generated.'
  # end

  # def join_by_code
  #   target_organization = Organization.where(name: params[:name]).first

  #   if target_organization.nil?
  #     redirect_to :back, notice: 'Organization does not exist.' and return
  #   end

  #   if target_organization.access_code != params[:access_code]
  #     redirect_to :back, notice: 'Wrong access code.' and return
  #   end

  #   OrganizationMembership.create(organization_id: target_organization.id, user_id: params[:user_id], admin: false)
  #   redirect_to target_organization, notice: 'Successfully joined organization.'
  # end

  # POST /organizations/1/manage_users
  def manage_users
    # if ask to manage users
    if !params[:department_entry_id].nil?
      @url = Rails.env.production? ? request.host : request.host_with_port
      @department_entry = DepartmentEntry.find(params[:department_entry_id])
      @organization = current_organization

      params[:invitee_list].split(/[,;]/).each do |target_email|
        @user = User.where(email: target_email).first
        if @user.nil?
          # generate invite, send email
          existing_invite = UserInvite.where(email: target_email, department_entry: @department_entry, organization: current_organization).first
          if !existing_invite
            UserInvite.create(email: target_email, department_entry: @department_entry, organization: current_organization)
          end
          Notifier.user_invitation(target_email, @organization, @url, current_user).deliver_now
        else
          # add & send email about update
          existing_membership = DepartmentEntryMembership.where(department_entry: @department_entry, user: @user).first
          if !existing_membership
            DepartmentEntryMembership.create(department_entry: @department_entry, user: @user)
            Notifier.new_department_assignment(@user, @organization, @url, @department_entry.department_name).deliver_now
          end
        end
      end
      params[:admin_list].split(/[,;]/).each do |target_email|
        @user = User.where(email: target_email).first
        if @user.nil?
          # generate invite, send email, decision maker
          existing_invite = UserInvite.where(email: target_email, department_entry: @department_entry, organization: current_organization).first
          if !existing_invite
            UserInvite.create(email: target_email, department_entry: @department_entry, admin: true, organization: current_organization)
          elsif !existing_invite.admin
            existing_invite.update(admin: true)
          end
          Notifier.user_invitation(target_email, @organization, @url, current_user).deliver_now
        else
          # add & send email about update, decision maker
          existing_membership = DepartmentEntryMembership.where(department_entry: @department_entry, user: @user).first
          if !existing_membership
            DepartmentEntryMembership.create(department_entry: @department_entry, user: @user)
            Notifier.new_department_assignment(@user, @organization, @url, @department).deliver_now
          elsif !existing_membership.admin
            existing_membership.update(admin: true)
          end
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def update_departments
    # set new department entries
    @organization.department_entries.each{|x| x.destroy}
    params[:departments].each do |d_id|
      DepartmentEntry.create(context: @organization, department_id: d_id)
    end
    redirect_to :back
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    @pic = Picture.new
    if params[:organization][:pictures] != nil
      @pic.image = params[:organization][:pictures][:image]
      if @pic.save
        @organization.picture = @pic
        @organization.save
      end
    end
    if @organization.update(organization_params)
      if organization_params[:new_subscription]
        Subscription.create(organization_id: @organization.id,
          end_at: organization_params[:new_subscription].to_date,
          subscription_type: 'standard', active: true)
      end
      redirect_to :back
    else
      @pic.delete
      redirect_to :back
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name, :access_token, :twitter_handle, :twitter_widget_id, :facebook_page_handle, :new_subscription)
    end
end
