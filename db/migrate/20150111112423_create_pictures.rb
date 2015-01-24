class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
    	t.integer :post_id
    	t.integer :user_id
    	t.integer :organization_id
      t.timestamps
    end
  end
end
