class AddOpinionToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :opinion, :integer, default: 0
  end
end
