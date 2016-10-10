class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |x|
      x.string :content
      x.integer :user_id
    end
  end
end
