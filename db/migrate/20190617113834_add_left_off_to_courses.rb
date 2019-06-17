class AddLeftOffToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :left_off, :integer
  end
end
