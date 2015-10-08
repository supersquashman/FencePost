class CreateTableEquipmentTypes < ActiveRecord::Migration
  def change
    create_table :equipment_types do |t|
      t.text :description
    end
  end
end
