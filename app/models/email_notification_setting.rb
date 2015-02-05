class EmailNotificationSetting < ActiveRecord::Base
  belongs_to :timed_task
  belongs_to :user
end
