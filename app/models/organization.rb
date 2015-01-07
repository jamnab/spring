class Organization < ActiveRecord::Base
  attr_accessor :username
  has_many :projects
  
  # has_many :posts, through: :projects

  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships

  validates :name, uniqueness: true

  def new_token
  	access_token = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  	self.update_attributes(:access_token => access_token)
  end
end
