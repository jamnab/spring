class RenameOpinionable < ActiveRecord::Migration
  def change
    rename_column :opinions, :opinionble_id, :opinionable_id
  end
end
