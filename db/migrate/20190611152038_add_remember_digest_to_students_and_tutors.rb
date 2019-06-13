class AddRememberDigestToStudentsAndTutors < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :remember_digest, :string
    add_column :tutors, :remember_digest, :string
  end
end
