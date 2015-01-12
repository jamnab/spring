class Picture < ActiveRecord::Base

	belongs_to :post 

	has_attached_file :image, :styles => {:post_image => "140x110>",:user_image => "60x60>"}
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end