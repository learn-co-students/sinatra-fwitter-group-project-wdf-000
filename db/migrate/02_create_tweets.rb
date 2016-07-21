class CreateTweets < ActiveRecord::Migration
  def change
    create_table :Tweets do |t|
      t.string :content
      t.integer :user_id
    end
  end
end