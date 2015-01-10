class Post < ActiveRecord::Base
  searchkick
  belongs_to :user
  belongs_to :organization

  has_many :tag_entries, as: :taggable, dependent: :destroy
  has_many :tags, through: :tag_entries

  has_many :label_entries, as: :labelable, dependent: :destroy
  has_many :labels, through: :label_entries

  has_many :comments, as: :commentable, dependent: :destroy 
  has_many :opinions, as: :opinionable, dependent: :destroy

  WORK = 0
  PLAY = 1
  FACILITY = 2

  def doit?
    return (self.traction > self.threshold)
  end
end
# joins(:chapters).
#                  select('books.id, count(chapters.id) as n_chapters').
