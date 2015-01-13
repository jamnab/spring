class OrganizationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :generate_code]

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all
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
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    @organization.access_code = ('a'..'z').to_a.shuffle[0,32].join

    respond_to do |format|
      if @organization.save
        OrganizationMembership.create(user_id: current_user.id, organization_id: @organization.id, admin: true)
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def generate_code
    @prev = @organization.access_token
    @new = ('a'..'z').to_a.shuffle[0,32].join
    @organization.update_attribute(:access_token, @new)
    @user = current_user
    @url = Rails.env.production? ? request.host : request.host_with_port
    Notifier.register_form(@user,@organization,@url).deliver!
    @organization.delay(run_at: 1.minute.from_now).update_attribute(:access_token, nil)
    @time = Time.now
    redirect_to @organization, notice: 'New access code generated.'
  end

  def join_by_code
    target_organization = Organization.where(name: params[:name]).first

    if target_organization.nil?
      redirect_to :back, notice: 'Organization does not exist.' and return
    end

    if target_organization.access_code != params[:access_code]
      redirect_to :back, notice: 'Wrong access code.' and return
    end

    OrganizationMembership.create(organization_id: target_organization.id, user_id: params[:user_id], admin: false)
    redirect_to target_organization, notice: 'Successfully joined organization.'
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
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
      params.require(:organization).permit(:name, :access_code)
    end
end
