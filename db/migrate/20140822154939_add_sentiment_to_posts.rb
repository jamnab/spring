class AddSentimentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :sentiment_percentage, :integer
    add_column :posts, :sentiment_category, :integer
  end
end
