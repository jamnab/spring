class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.integer :post_id
      t.boolean :private, default: true

      t.timestamps null: false
    end
  end
end
