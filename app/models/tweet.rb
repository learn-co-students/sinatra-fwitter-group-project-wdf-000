class Tweet < ActiveRecord::Base
  belongs_to :user

  def slug
    @input = self.name.gsub(/\s|\W/,'-').downcase
  end

  def self.find_by_slug(slug)
    Tweet.all.find do |a|
      slug == a.slug
    end
  end
  
end
