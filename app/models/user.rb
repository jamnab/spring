class User < ActiveRecord::Base
  attr_accessor :organization_name
  attr_accessor :organization_token
  attr_accessor :is_manager

  acts_as_authentic

  has_many :posts
  has_many :comments
  has_many :opinion

  has_many :project_memberships, dependent: :destroy
  has_many :projects, through: :project_memberships

  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
