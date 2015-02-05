class Picture < ActiveRecord::Base

	belongs_to :post 
	belongs_to :user
	belongs_to :organization
	
	has_attached_file :image, 
		:styles => {:user_image => "60x60>",:organization_image => "x40",:post_image => "150x100!", :max_image => "x500"},
		:path => ":rails_root/public/images/:id/:filename",
    :url  => "/images/:id/:filename"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end