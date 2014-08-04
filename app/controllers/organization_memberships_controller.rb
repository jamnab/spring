class OrganizationMembershipsController < ApplicationController
  before_action :set_organization_membership, only: [:destroy]

  # POST /organization_memberships
  # POST /organization_memberships.json
  def create
    @organization_membership = OrganizationMembership.new(organization_membership_params)

    if @organization_membership.username
      target_user = User.where(username: @organization_membership.username).first

      if !target_user
        redirect_to :back, notice: 'User does not exist.' and return
      end

      if @organization_membership.organization.organization_memberships.map{|x| x.user}.include? target_user
        redirect_to :back, notice: 'User already in organization.' and return
      end

      @organization_membership.user_id = target_user.id
    end

    respond_to do |format|
      if @organization_membership.save
        format.html { redirect_to @organization_membership.organization, notice: 'Organization membership was successfully created.' }
        format.json { render action: 'show', status: :created, location: @organization_membership }
      else
        format.html { render action: 'new' }
        format.json { render json: @organization_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    @organization = @organization_membership.organization
    if @organization_membership.admin && @organization.organization_memberships.where(admin: true).count <= 1
      redirect_to @organization, notice: 'Cannot remove sole admin, please assign a new admin or just destroy the organization entirely.' and return
    end

    @organization_membership.admin = !@organization_membership.admin
    @organization_membership.save

    redirect_to :back, notice: "Permission updated."
  end

  # DELETE /organization_memberships/1
  # DELETE /organization_memberships/1.json
  def destroy
    @organization = @organization_membership.organization
    if @organization_membership.admin && @organization.organization_memberships.where(admin: true).count <= 1
      redirect_to @organization, notice: 'Cannot remove sole admin, please assign a new admin or just destroy the organization entirely.' and return
    end

    @organization_membership.destroy
    respond_to do |format|
      format.html { redirect_to @organization }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_membership
      @organization_membership = OrganizationMembership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_membership_params
      params.require(:organization_membership).permit(:user_id, :organization_id, :admin, :username)
    end
end
