class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :content
      t.boolean :read, default: false
      t.integer :user_id
      t.string :user_type

      t.timestamps
    end
  end
end
