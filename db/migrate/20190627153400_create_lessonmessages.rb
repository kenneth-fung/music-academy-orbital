class CreateLessonmessages < ActiveRecord::Migration[5.2]
  def change
    create_table :lessonmessages do |t|
      t.references :message, foreign_key: true, index: true
      t.references :lesson, foreign_key: true, index: true

      t.timestamps
    end
  end
end
