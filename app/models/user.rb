require 'pry'
class User < ActiveRecord::Base
	has_secure_password
	has_many :tweets

	def slug
		@user = self.username.split(" ").join("-")
		@user
	end

	def self.find_by_slug(slug)
		User.all.find do |username|
			username.slug == slug 
			# binding.pry
		end
	end


end