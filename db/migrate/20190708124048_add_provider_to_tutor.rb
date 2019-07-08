class AddProviderToTutor < ActiveRecord::Migration[5.2]
  def change
    add_column :tutors, :provider, :string
  end
end
