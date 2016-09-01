# DEPRECATED
class BetaSignUpsController < ApplicationController
  load_and_authorize_resource except: [:register]
  before_action :set_bsu_with_code, only: [:register]
  layout :action_layout

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

  def create
    @beta_sign_up = BetaSignUp.new beta_sign_up_params

    @beta_sign_up.signup_code = SecureRandom.urlsafe_base64

    respond_to do |format|
      format.html do
        if @beta_sign_up.save && BetaSignUpMailer.beta_mailing_list_to_clint(@beta_sign_up).deliver_now
          flash[:notice] = "You have been put on our beta mailing list. We will notify you when you are approved to sign in."
          redirect_to :root
        else
          flash[:error] = "Sorry there was a problem adding you to the beta mailing list. Please try again later."
          redirect_to :root
        end
      end
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

  def action_layout
    if params[:action] == 'register'
      "application_no_nav"
    else
      "application"
    end
  end

  def beta_sign_up_params
    params.require(:beta_sign_up).permit(:first_name, :last_name, :email )
  end

  def set_bsu_with_code
    @beta_sign_up = BetaSignUp.find_by_signup_code params[:id]
  end
end
