class AddPrivateToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :private, :boolean, default: false
  end
end
