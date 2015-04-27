class CreateUserInvites < ActiveRecord::Migration
  def change
    create_table :user_invites do |t|
      t.string :email
      t.integer :department_entry_id
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
