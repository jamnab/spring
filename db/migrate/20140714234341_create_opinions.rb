class CreateOpinions < ActiveRecord::Migration
  def change
    create_table :opinions do |t|
      t.boolean :positive, default: true
      t.integer :opinionble_id
      t.string :opinionable_type

      t.timestamps
    end
  end
end
