class DepartmentEntriesController < ApplicationController
  before_action :set_department_entry, only: [:fetch_users, :destroy]

  # POST /department_entries
  # POST /department_entries.json
  def create
    @department_entry = DepartmentEntry.new(department_entry_params)

    respond_to do |format|
      if @department_entry.save
        format.html { redirect_to :back, notice: 'Department entry was successfully created.' }
        format.json { render :show, status: :created, location: @department_entry }
      else
        format.html { render :new }
        format.json { render json: @department_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /department_entries/1
  # DELETE /department_entries/1.json
  def destroy
    @department_entry.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def fetch_users
    @user_memberships = @department_entry.department_entry_memberships.where(admin: false)
    @admin_memberships = @department_entry.department_entry_memberships.where(admin: true)

    respond_to do |format|
      format.html {redirect_to :back}
      format.js {render 'pages/de_fetch_users'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department_entry
      @department_entry = DepartmentEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_entry_params
      params.require(:department_entry).permit(:context_id, :context_type, :department_id, :department_name, :abbrev_name, :approval_required)
    end
end
