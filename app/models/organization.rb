class Organization < ActiveRecord::Base
  attr_accessor :username
  has_many :projects
  # has_many :posts, through: :projects

  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships
end