class User < ActiveRecord::Base
  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
  has_many :tweets
  validates_presence_of :username, :email, :password
  has_secure_password
end