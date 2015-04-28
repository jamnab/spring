class RemoveThresholdFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :threshold, :integer
  end
end
