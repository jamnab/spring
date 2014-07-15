class Project < ActiveRecord::Base
  attr_accessor :username
  belongs_to :organization
  has_many :posts

  has_many :project_memberships, dependent: :destroy
  has_many :users, through: :project_memberships
end
