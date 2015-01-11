class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :first_name
      t.string :last_name
      t.string :job_title
      t.integer :organization_id
      t.boolean :manager, default: false
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
