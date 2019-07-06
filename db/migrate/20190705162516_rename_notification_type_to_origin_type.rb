class RenameNotificationTypeToOriginType < ActiveRecord::Migration[5.2]
  def change
    rename_column :notifications, :type, :origin_type
  end
end
