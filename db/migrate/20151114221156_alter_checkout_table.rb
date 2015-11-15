class AlterCheckoutTable < ActiveRecord::Migration
  def change
      remove_column :checkout_table, :time_returned
      remove_column :checkout_table, :time_return_approved
      rename_column :checkout_table, :time_requested, :time_opened
      rename_column :checkout_table, :time_request_processed, :time_closed
      add_reference :checkout_table, :request_types, foreign_key: true
  end
end
