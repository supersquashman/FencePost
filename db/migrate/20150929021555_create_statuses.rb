class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :status_desc

      t.timestamps null: false
    end
  end
end
