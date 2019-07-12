class AddUnreadToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :unread, :integer, default: 0
  end
end
