class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.boolean :anonymous, default: false
      t.integer :threshold
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
