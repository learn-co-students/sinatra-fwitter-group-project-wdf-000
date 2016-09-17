class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def slug
    self.username.downcase.split(" ").join("-")
    # binding.pry
  end

  def self.find_by_slug(arg)
    self.all.find do |song|
      if song.slug == arg
        song
      end
    end
  end

end
