class Opinion < ActiveRecord::Base
  belongs_to :user
  belongs_to :opinionable, polymorphic: true

  scope :like, -> { where(positive: true) }
  scope :unlike, -> { where(positive: false) }
end
