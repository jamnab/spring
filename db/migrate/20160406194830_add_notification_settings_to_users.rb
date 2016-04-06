class AddNotificationSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notification_settings, :string, default: User::NOTIFICATION_DEFAULT
  end
end
