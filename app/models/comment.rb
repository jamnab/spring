class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true

  # has_many :tag_entries, as: :taggable, dependent: :destroy
  # has_many :tags, through: :tag_entries

  # has_many :label_entries, as: :labelable, dependent: :destroy
  # has_many :labels, through: :label_entries

  has_many :opinions, as: :opinionable

  def self.all_doits
    joins( "INNER JOIN `posts` ON `comments`.`commentable_id` = `posts`.`id`" ) \
    .where( :comments => { commentable_type: 'Post' } ) \
    .where( "`comments`.opinion >= `posts`.threshold" )
  end

  def doit?
    self.opinion > self.commentable.threshold
  end

  def is_suggestion?
    self.suggestion
  end
end
