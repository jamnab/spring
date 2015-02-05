class Post < ActiveRecord::Base
  include PublicActivity::Common
  
  searchkick
  validates :content, length: { maximum: 256}
  belongs_to :user
  belongs_to :organization

  has_many :favourites

  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures

  # has_many :tag_entries, as: :taggable, dependent: :destroy
  # has_many :tags, through: :tag_entries

  # has_many :label_entries, as: :labelable, dependent: :destroy
  # has_many :labels, through: :label_entries

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :opinions, as: :opinionable, dependent: :destroy

  WORK = 0
  PLAY = 1
  FACILITY = 2
  TYPES = [{'name' => 'Work', 'id' => WORK},
           {'name' => 'Play', 'id' => PLAY},
           {'name' => 'Facility', 'id' => FACILITY}]

  def self.all_doits
    where("opinion >= threshold")
  end

  def self.all_alt_doits
    Post.find_by_sql("SELECT `posts`.* FROM `posts` INNER JOIN `comments` ON `comments`.`commentable_id` = `posts`.`id` AND `comments`.`commentable_type` = 'Post' AND `comments`.opinion >= `posts`.threshold")
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

  def type?
    if self.post_type == 0
      return "work"
    elsif self.post_type == 1
      return "play"
    else
      return "facility"
    end
  end
end
# joins(:chapters).
#                  select('books.id, count(chapters.id) as n_chapters').
