class Picture < ActiveRecord::Base

	belongs_to :post 

	has_attached_file :image, 
		:styles => {:user_image => "60x60>",:post_image => "170x110>"},
		:path => ":rails_root/public/images/:id/:filename",
    :url  => "/images/:id/:filename"
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end