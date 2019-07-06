class AddOriginIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :origin_id, :integer
  end
end
