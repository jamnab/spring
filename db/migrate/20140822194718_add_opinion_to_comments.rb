class AddOpinionToComments < ActiveRecord::Migration
  def change
    add_column :comments, :opinion, :integer, default: 0
  end
end
