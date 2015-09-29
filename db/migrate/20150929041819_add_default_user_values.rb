class AddDefaultUserValues < ActiveRecord::Migration
  def change
    change_column_default :users, :dues, false
    change_column_default :users, :waiver, false
  end
end
