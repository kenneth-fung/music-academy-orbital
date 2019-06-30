class AddIndexToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :chatroom_id, :integer
    add_column :messages, :chatroom_type, :string
    add_index :messages, [:chatroom_type, :chatroom_id]
  end
end
