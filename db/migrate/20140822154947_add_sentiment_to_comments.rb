class AddSentimentToComments < ActiveRecord::Migration
  def change
    add_column :comments, :sentiment_percentage, :integer
    add_column :comments, :sentiment_category, :integer
  end
end
