class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def slug
    @input = self.username.gsub(/\s|\W/,'-').downcase
  end

  def self.find_by_slug(slug)
    User.all.find do |a|
      slug == a.slug
    end
  end

end
