class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.boolean :endorsed, default: false
      t.boolean :anonymous, default: false
      t.boolean :suggestion, default: false
      t.integer :opinion, default: 0
      t.integer :user_id
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end
  end
end
