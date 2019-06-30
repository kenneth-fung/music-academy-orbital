class AddReferencesToMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :messages, :post, foreign_key: true
    add_column :messages, :user_id, :integer
    add_column :messages, :user_type, :string
  end
end
