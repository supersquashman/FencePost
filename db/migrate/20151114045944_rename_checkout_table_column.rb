class RenameCheckoutTableColumn < ActiveRecord::Migration
  def change
     rename_column :checkout_table, :time_request_approved, :time_request_processed
  end
end
