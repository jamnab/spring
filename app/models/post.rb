class Post < ActiveRecord::Base
  searchkick
  belongs_to :user
  belongs_to :organization

  has_many :favourites

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

  def doit?
    return (self.opinion > self.threshold) || self.alt_doit?
  end

  def alt_doit?
    # check for comment doit
    return !self.comments.select{|x| x.doit?}.empty?
  end
end
