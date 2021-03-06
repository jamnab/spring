class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.boolean :anonymous, default: true
      t.integer :threshold, default: 20
      t.integer :opinion, default: 0
      t.integer :user_id
      t.integer :organization_id
      # t.integer :post_type
      t.boolean :graveyard, default: false

      t.timestamps
    end
  end
end
