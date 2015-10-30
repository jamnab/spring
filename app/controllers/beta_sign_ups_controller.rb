class BetaSignUpsController < ApplicationController
  load_and_authorize_resource except: [:register]
  before_action :set_bsu_with_code, only: [:register]
  def index
    @beta_sign_ups = BetaSignUp.where(workflow_state: 'pending')
  end

  def approve
    @beta_sign_up.approve!

    respond_to do |format|
      format.js
    end
  end

  def deny
    @beta_sign_up.deny!

    respond_to do |format|
      format.js
    end
  end

  def register
    respond_to do |format|
      format.html do
        if !@beta_sign_up.try(:user).blank?
          render plain: "This code has already been used"
        elsif @beta_sign_up.pending?
          render plain: "This beta sign up is not approved yet"
        end
      end
    end
  end

  private

  def set_bsu_with_code
    @beta_sign_up = BetaSignUp.find_by_signup_code params[:id]
  end
end
