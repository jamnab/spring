class Asset < ActiveRecord::Base
  belongs_to :post

  has_attached_file :document,
    storage: :azure,
    url: ":azure_path_url"

  # validates_attachment_content_type :document, :content_type => /\Adocument\/.*\Z/
end
