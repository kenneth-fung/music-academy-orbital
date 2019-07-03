class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :content
      t.references :student, foreign_key: true
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
