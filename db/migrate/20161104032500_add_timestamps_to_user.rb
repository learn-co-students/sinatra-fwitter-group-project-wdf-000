class AddTimestampsToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.timestamps
    end
  end
end
