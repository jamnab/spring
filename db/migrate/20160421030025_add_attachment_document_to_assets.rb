class AddAttachmentDocumentToAssets < ActiveRecord::Migration
  def self.up
    change_table :assets do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :assets, :document
  end
end
