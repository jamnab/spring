# Preview all emails at http://localhost:3000/rails/mailers/organizations
class OrganizationsMailerPreview < ActionMailer::Preview

  def notify_clinton
    OrganizationsMailer.notify_clinton(Organization.first)
  end

  def notify_manager_of_approval
    OrganizationsMailer.notify_manager_of_approval(Organization.first.managers.first)
  end
end
