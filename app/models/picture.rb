class Picture < ActiveRecord::Base
	belongs_to :post
	belongs_to :user
	belongs_to :organization

	has_attached_file :image,
    :storage: :azure,
		:styles => {:user_image => "60x60>",:organization_image => "x40",:post_image => "150x100!", :max_image => "x500"},
    :url  => ":azure_path_url"

	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
