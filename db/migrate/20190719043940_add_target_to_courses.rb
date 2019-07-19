class AddTargetToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :target, :text
  end
end
