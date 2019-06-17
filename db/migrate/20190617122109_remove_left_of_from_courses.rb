class RemoveLeftOfFromCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :courses, :left_off, :integer
  end
end
