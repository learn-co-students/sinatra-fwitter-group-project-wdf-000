class ChangeColForUsers < ActiveRecord::Migration
  def change
  	rename_column :users, :password, :password_digest
  end
end
