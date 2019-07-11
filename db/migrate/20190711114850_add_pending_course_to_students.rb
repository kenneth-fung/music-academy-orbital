class AddPendingCourseToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :pending_course, :integer
  end
end
