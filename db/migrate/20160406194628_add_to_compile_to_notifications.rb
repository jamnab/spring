class AddToCompileToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :to_compile, :boolean, default: false
  end
end
