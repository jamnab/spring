class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :access_token
      t.boolean :activated, default: false

      t.timestamps
    end
  end
end
