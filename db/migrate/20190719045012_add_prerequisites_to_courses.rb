class AddPrerequisitesToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :prerequisites, :text
  end
end
