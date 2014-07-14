class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  has_many :tag_entries, as: :taggable, dependent: :destroy
  has_many :tags, through: :tag_entries

  has_many :label_entries, as: :labelable, dependent: :destroy
  has_many :labels, through: :label_entries

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :opinions, as: :opinionable, dependent: :destroy
end
