class DepartmentEntry < ActiveRecord::Base
  belongs_to :context, polymorphic: true
  # belongs_to :department
  belongs_to :decision_maker, class_name: 'User'

  has_many :post_department_entries
  has_many :posts, through: :post_department_entries

  has_many :comments, through: :posts
  has_many :opinions, through: :posts

  has_many :department_entry_memberships, dependent: :destroy
  has_many :users, through: :department_entry_memberships

  def managers
    self.department_entry_memberships.where(admin: true).map{|x| x.user}
  end
end
