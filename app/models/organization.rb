class Organization < ActiveRecord::Base
  attr_accessor :username
  has_many :posts
  has_one :picture
  accepts_nested_attributes_for :picture

  has_many :comments, through: :posts

  has_many :department_entries, as: :context
  # has_many :posts, through: :department_entries

  has_many :department_entry_memberships, through: :department_entries
  has_many :users, through: :department_entry_memberships

  DEP_LIMIT = 5

  validates :name, uniqueness: true

  has_many :managers, -> {where(manager: true)}, class_name: 'User'
  has_many :admins, -> {where(admin: true)}, class_name: 'User'

  def departments
    self.department_entries.map{|x| x.department_name}
  end

  def new_token
  	access_token = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  	self.update_attributes(:access_token => access_token)
  end

  def activity_count
    (self.posts.count + self.comments.count)
  end

  def doit_post_count
    self.posts.select{|x| x.doit?}.count
  end

  def doit_comment_count
    self.comments.select{|x| x.doit?}.count
  end

  def doit_count
    self.doit_post_count + self.doit_comment_count
  end

end
