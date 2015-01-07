module TokenHelper
	def self.newToken
		@Organization = Organization.all
		@Organization.each do |o|
			o.access_token = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
			o.save
		end
	end

end