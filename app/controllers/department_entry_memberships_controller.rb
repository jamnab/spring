class DepartmentEntryMembershipsController < ApplicationController
  before_action :set_department_entry_membership, only: [:destroy]

  # POST /department_entry_memberships
  # POST /department_entry_memberships.json
  def create
    @department_entry_membership = DepartmentEntryMembership.new(department_entry_membership_params)

    respond_to do |format|
      if @department_entry_membership.save
        format.html { redirect_to @department_entry_membership, notice: 'Department entry membership was successfully created.' }
        format.json { render :show, status: :created, location: @department_entry_membership }
      else
        format.html { render :new }
        format.json { render json: @department_entry_membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /department_entry_memberships/1
  # DELETE /department_entry_memberships/1.json
  def destroy
    @department_entry = @department_entry_membership.department_entry
    @department_entry_membership.destroy

    @user_memberships = @department_entry.department_entry_memberships.where(admin: false)
    @admin_memberships = @department_entry.department_entry_memberships.where(admin: true)

    respond_to do |format|
      format.html { redirect_to department_entry_memberships_url, notice: 'Department entry membership was successfully destroyed.' }
      format.js {render 'pages/de_fetch_users'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department_entry_membership
      @department_entry_membership = DepartmentEntryMembership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_entry_membership_params
      params.require(:department_entry_membership).permit(:user_id, :department_entry_id, :admin)
    end
end
