class ProjectMembershipsController < ApplicationController
  before_action :set_project_membership, only: [:destroy]

  # POST /project_memberships
  # POST /project_memberships.json
  def create
    @project_membership = ProjectMembership.new(project_membership_params)

    if @project_membership.username
      target_user = User.where(username: @project_membership.username).first

      if !target_user
        redirect_to :back, notice: 'User does not exist.' and return
      end

      if @project_membership.project.project_memberships.map{|x| x.user}.include? target_user
        redirect_to :back, notice: 'User already in project.' and return
      end

      @project_membership.user_id = target_user.id
    end

    respond_to do |format|
      if @project_membership.save
        format.html { redirect_to @project_membership.project, notice: 'Project membership was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project_membership }
      else
        format.html { render action: 'new' }
        format.json { render json: @project_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def toggle
    @project = @project_membership.project
    if @project_membership.admin && @project.project_memberships.where(admin: true).count <= 1
      redirect_to @project, notice: 'Cannot remove sole admin, please assign a new admin or just destroy the project entirely.' and return
    end

    @project_membership.admin = !@project_membership.admin
    @project_membership.save

    redirect_to :back, notice: "Permission updated."
  end

  # DELETE /project_memberships/1
  # DELETE /project_memberships/1.json
  def destroy
    @project = @project_membership.project
    if @project_membership.admin && @project.project_memberships.where(admin: true).count <= 1
      redirect_to @project, notice: 'Cannot remove sole admin, please assign a new admin or just destroy the project entirely.' and return
    end

    @project_membership.destroy
    respond_to do |format|
      format.html { redirect_to @project }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_membership
      @project_membership = ProjectMembership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_membership_params
      params.require(:project_membership).permit(:user_id, :project_id, :admin, :username)
    end
end
