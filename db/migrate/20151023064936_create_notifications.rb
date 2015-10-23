class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
	t.text :message
	t.boolean :viewed
	t.datetime :timestamp
    end
    add_reference :notifications, :to_user, references: :users
    add_reference :notifications, :from_user, references: :users
  end
end
