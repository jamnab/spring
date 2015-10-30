class CreateBetaSignUps < ActiveRecord::Migration
  def change
    create_table :beta_sign_ups do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :workflow_state
      t.string :signup_code
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
