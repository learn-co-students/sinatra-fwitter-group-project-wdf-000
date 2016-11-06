class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :users, :password, :password_digest
  end
end
