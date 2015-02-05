class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :activity, :class_name => "PublicActivity::Activity"
end
