class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :access_code
      t.integer :threshold
      t.integer :organization_id

      t.timestamps
    end
  end
end
