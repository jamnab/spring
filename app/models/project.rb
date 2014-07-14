class Project < ActiveRecord::Base
  has_many :posts

  has_many :project_memberships, dependent: :destroy
  has_many :users, through: :project_memberships
end
