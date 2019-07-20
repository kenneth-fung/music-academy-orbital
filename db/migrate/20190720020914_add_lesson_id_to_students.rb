class AddLessonIdToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :lesson_id, :integer
  end
end
