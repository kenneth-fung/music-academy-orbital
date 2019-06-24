class AddIndexToTaggings < ActiveRecord::Migration[5.2]
  def change
    add_index :taggings, [:course_id, :tag_id], unique: true
  end
end
