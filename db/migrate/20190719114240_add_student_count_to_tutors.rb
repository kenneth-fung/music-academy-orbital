class AddStudentCountToTutors < ActiveRecord::Migration[5.2]
  def change
    add_column :tutors, :student_count, :integer, default: 0
  end
end
