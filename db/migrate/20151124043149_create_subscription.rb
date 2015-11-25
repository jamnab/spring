class CreateSubscription < ActiveRecord::Migration
  def up
    change_table :subscriptions do |t|
      t.belongs_to :organization
      t.string :subscription_type
      t.remove :note
      t.remove :email
      t.datetime :end_at
      t.boolean :active

    end
  end

  def down
    change_table :subscriptions do |t|
      t.remove :organization_id
      t.remove :subscription_type
      t.string :note
      t.string :email
      t.remove :end_at
      t.remove :active
    end
  end
end
