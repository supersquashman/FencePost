class AddEquipmentTypeToEquipment < ActiveRecord::Migration
  def change
    add_reference :equipment, :equipment_type, foreign_key: true
  end
end
