class ChangeCourseContentToText < ActiveRecord::Migration[5.2]
  def up
    change_column :courses, :content, :text
  end

  def down
    change_column :courses, :content, :string
  end
end
