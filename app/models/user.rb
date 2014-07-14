class User < ActiveRecord::Base
  acts_as_authentic

  has_many :posts
  has_many :comments
  has_many :opinion
  has_many :project_memberships, dependent: :destroy
  has_many :organization_memberships, dependent: :destroy
end
