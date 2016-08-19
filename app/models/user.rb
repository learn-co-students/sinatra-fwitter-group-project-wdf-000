class User < ActiveRecord::Base
  validates_presence_of :username, on: :create
  validates_presence_of :password, on: :create
  validates_presence_of :email, on: :create
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create

  validates_length_of :username, within: 4..20, too_long: 'pick a shorter name', too_short: 'pick a longer name'
  validates_length_of :password, minimum: 4, too_short: 'password needs to be at least 4 characters long'

  has_many :tweets
  has_secure_password


  def slug
    self.username.split(/\s+/).collect{|name_part| name_part.gsub(/\W/,"")}.join("-").downcase
  end

  def self.find_by_slug(slugified_name)
    self.all.detect {|item| item.slug == slugified_name }
  end

end
