class AddPopularityToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :popularity, :integer, default: 0
  end
end
