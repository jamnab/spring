class Asset < ActiveRecord::Base
  belongs_to :post

  has_attached_file :document,
    storage: :azure,
    url: ":azure_path_url"

  validates_attachment_content_type :document, :content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.ms-excel image/vnd.adobe.photoshop text/plain)
end
