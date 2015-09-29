class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :dues, :boolean
    add_column :users, :waiver, :boolean
  end
end
