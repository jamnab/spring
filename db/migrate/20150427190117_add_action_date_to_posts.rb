class AddActionDateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :action_date, :date
    add_column :posts, :launch_approved, :boolean, default: false
  end
end
