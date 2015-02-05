class CreateEmailNotificationSettings < ActiveRecord::Migration
  def change
    create_table :email_notification_settings do |t|
    	t.string :settings_for
      t.belongs_to :timed_task, index: true
      t.belongs_to :user, index: true
      t.timestamps null: false
    end
  end
end
