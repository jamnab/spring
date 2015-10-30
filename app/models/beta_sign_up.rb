class BetaSignUp < ActiveRecord::Base
  belongs_to :user

  include Workflow

  workflow do
    state :pending do
      event :approve, transitions_to: :approved
      event :deny, transitions_to: :denied
    end

    state :approved

    state :denied
  end

  def approve
    BetaSignUpMailer.approved(self).deliver_now
  end

  def deny
    BetaSignUpMailer.approved(self).deliver_now
  end
end
