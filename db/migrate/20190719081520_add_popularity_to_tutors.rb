class AddPopularityToTutors < ActiveRecord::Migration[5.2]
  def change
    add_column :tutors, :popularity, :float, default: 0
  end
end
