class AddQualificationToTutors < ActiveRecord::Migration[5.2]
  def change
    add_column :tutors, :qualification, :string
  end
end
