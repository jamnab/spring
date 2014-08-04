class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :generate_code, :management, :search]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    if params[:query]
      raise
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  def management
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.access_code = ('a'..'z').to_a.shuffle[0,32].join

    respond_to do |format|
      if @project.save
        ProjectMembership.create(user_id: current_user.id, project_id: @project.id, admin: true)
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def generate_code
    @project.access_code = ('a'..'z').to_a.shuffle[0,32].join
    @project.save
    redirect_to @project, notice: 'New access code generated.'
  end

  def join_by_code
    target_organization = Project.where(name: params[:name]).first

    if target_organization.nil?
      redirect_to :back, notice: 'Project does not exist.' and return
    end

    if target_organization.access_code != params[:access_code]
      redirect_to :back, notice: 'Wrong access code.' and return
    end

    ProjectMembership.create(organization_id: target_organization.id, user_id: params[:user_id], admin: false)
    redirect_to target_organization, notice: 'Successfully joined organization.'
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
      @organization = @project.organization
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :access_code, :threshold, :organization_id)
    end
end
