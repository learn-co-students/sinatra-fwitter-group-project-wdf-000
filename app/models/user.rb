require 'pry'
class User < ActiveRecord::Base
  has_many :tweets
  has_secure_password

  def slug
    username.gsub(" ","-")
  end

  def self.find_by_slug(slug_name)
    # binding.pry
    User.all.detect {|username| username.slug == slug_name }
  end


end