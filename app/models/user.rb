class User < ActiveRecord::Base
  has_secure_password
	validates_presence_of :username, :password, :email

  has_many :tweets

  def slug
    self.username.downcase.gsub(/\s/,"-")
  end

  def self.find_by_slug(slug)
    User.all.detect { |x| x.slug == slug }
  end
end
