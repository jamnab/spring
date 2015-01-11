class User < ActiveRecord::Base
  # attr_accessor :is_manager
  attr_accessor :organization_name
  attr_accessor :organization_token

  acts_as_authentic

  has_many :posts
  has_many :comments
  has_many :opinion

  # has_many :project_memberships, dependent: :destroy
  # has_many :projects, through: :project_memberships

  belongs_to :organization

  # has_one :organization_membership, dependent: :destroy
  # has_one :organization, through: :organization_membership

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def is_manager?
    self.manager
  end

  def is_admin?
    self.admin
  end
end
