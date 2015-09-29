class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.text :title
      t.references :users

      t.timestamps null: false
    end
  end
end
