class AddLaunchedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :launched, :boolean, default: false
  end
end
