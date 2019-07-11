class AddDefaultPendingCourseToStudents < ActiveRecord::Migration[5.2]
  def change
    change_column_default :students, :pending_course, -1
  end
end
