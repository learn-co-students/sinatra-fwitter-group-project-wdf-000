class Tweet < ActiveRecord::Base
  belongs_to :user
  validates_length_of :content, within: 1..256, too_long: "Tweets can be max 255 characters long", too_short: "No blank tweets, please"
end
