class AddLeftOffToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :left_off, :integer, default: 1
  end
end
