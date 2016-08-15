class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |col|
      col.string :content
      col.integer :user_id
    end
  end
end
