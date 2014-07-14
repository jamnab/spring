class CreateLabelEntries < ActiveRecord::Migration
  def change
    create_table :label_entries do |t|
      t.integer :tag_id
      t.integer :labelable_id
      t.string :labelable_type

      t.timestamps
    end
  end
end
