class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.references :status
      t.string :parts
      t.references :users

      t.timestamps null: false
    end
  end
end
