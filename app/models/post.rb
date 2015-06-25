class Post < ActiveRecord::Base
  include PublicActivity::Common

  searchkick
  validates :content, length: { maximum: 256}
  belongs_to :user
  belongs_to :organization

  has_many :post_department_entries
  has_many :department_entries, through: :post_department_entries

  def departments
    self.department_entries.map{|x| x.department_name}
  end

  has_many :favourites

  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures

  # has_many :tag_entries, as: :taggable, dependent: :destroy
  # has_many :tags, through: :tag_entries

  # has_many :label_entries, as: :labelable, dependent: :destroy
  # has_many :labels, through: :label_entries

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :opinions, as: :opinionable, dependent: :destroy

  # PROJECT = 0
  # FUN = 1
  # FACILITY = 2
  # TYPES = [{'name' => 'Project', 'id' => PROJECT},
  #          {'name' => 'Fun', 'id' => FUN},
  #          {'name' => 'Facility', 'id' => FACILITY}]

  def threshold
    org = self.organization
    if self.departments.count == 0
      org_departments = org.department_entries
    else
      org_departments = DepartmentEntry.where(context: org).where('department_name in (?)', self.departments)
    end
    (0.7 * org_departments.map{|x| x.users.count}.inject(0, :+)).to_i
  end

  def self.all_doits
    # no more threshold field... what to do...
    # where("opinion >= ?", self.threshold)
  end

  def self.all_alt_doits
    Post.find_by_sql("SELECT `posts`.* FROM `posts` INNER JOIN `comments` ON `comments`.`commentable_id` = `posts`.`id` AND `comments`.`commentable_type` = 'Post' AND `comments`.opinion >= ?", self.threshold)
  end

  def doit?
    return (self.opinion >= self.threshold) || self.alt_doit?
  end

  def alt_doit?
    # check for comment doit
    return !self.comments.select{|x| x.doit?}.empty?
  end

  def favourited?(user)
    if !user.nil?
      return Favourite.where(user_id: user.id, fav_post_id: self.id).first
    end
    return nil
  end
end
