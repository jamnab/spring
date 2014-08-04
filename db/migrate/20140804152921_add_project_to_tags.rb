class AddProjectToTags < ActiveRecord::Migration
  def change
    add_column :tags, :project_id, :integer
  end
end
