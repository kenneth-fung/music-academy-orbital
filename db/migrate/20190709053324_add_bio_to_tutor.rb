class AddBioToTutor < ActiveRecord::Migration[5.2]
  def change
    add_column :tutors, :bio, :text
  end
end
