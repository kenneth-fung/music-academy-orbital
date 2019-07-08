class RemoveReadFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :read, :boolean
  end
end
