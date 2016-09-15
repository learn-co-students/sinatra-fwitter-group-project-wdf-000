class User < ActiveRecord::Base
  has_many :tweets
  has_many :contents, :through => :tweets

  # validates_presence_of :username, :email, :password

  has_secure_password

  def slug
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    User.all.find {|user| user.slug == slug}
  end
  
end
