class AddDescriptionToEquipment < ActiveRecord::Migration
  def change
    add_column :equipment, :description, :text
  end
end
