class AddTagListToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :tag_list, :string
  end
end
