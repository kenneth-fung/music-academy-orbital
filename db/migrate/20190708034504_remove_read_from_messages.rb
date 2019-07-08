class RemoveReadFromMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :read, :boolean
  end
end
