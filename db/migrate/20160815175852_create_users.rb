class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |col|
      col.string :username
      col.string :email
      col.string :password_digest
    end
  end
end
