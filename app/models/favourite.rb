class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :fav_post, class_name: 'Post'
end
