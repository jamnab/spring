class AddSubscribeToNewsletterToUser < ActiveRecord::Migration
  def change
    add_column :users, :subscribe_to_newsletter, :boolean, default: false
  end
end
