class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |col|
      col.string :tweet
      col.integer :user_id
    end
  end
end
