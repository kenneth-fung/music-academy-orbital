class AddUidToTutor < ActiveRecord::Migration[5.2]
  def change
    add_column :tutors, :uid, :string
  end
end
