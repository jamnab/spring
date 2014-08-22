class AddCommentAnonymityToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :comment_anonymity, :boolean, default: false
  end
end
