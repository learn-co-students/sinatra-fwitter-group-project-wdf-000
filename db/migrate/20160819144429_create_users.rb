class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_disgest # Does it add both :password and the extra column for salted password?
      t.timestamps
    end
  end
end
