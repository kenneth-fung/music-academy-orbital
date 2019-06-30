class DropTableLessonmessages < ActiveRecord::Migration[5.2]
  def change
    drop_table :lessonmessages
    remove_column :messages, :chatroom_id
    remove_column :messages, :chatroom_type
  end
end
