class AddIndexToMessages < ActiveRecord::Migration[5.2]
  def change
    add_index :messages, [:chatroom_type, :chatroom_id]
    add_column :messages, :chatroom_id, :integer
    add_column :messages, :chatroom_type, :string
  end
end
