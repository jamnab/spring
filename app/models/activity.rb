PublicActivity::Activity.class_eval do
  has_many :notifications
  has_many :users, through: :notifications
end
