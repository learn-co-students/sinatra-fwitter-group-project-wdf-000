class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |x|
      x.string :username
      x.string :email
      x.string :password
    end
  end
end
