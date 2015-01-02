class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.boolean :positive, default: true
      t.integer :opinionable_id
      t.string :opinionable_type
      t.integer :user_id

      t.timestamps
    end
  end
end
