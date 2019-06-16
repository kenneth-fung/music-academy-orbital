class AddAdminToTutors < ActiveRecord::Migration[5.2]
  def change
    add_column :tutors, :admin, :boolean, default: false
  end
end
