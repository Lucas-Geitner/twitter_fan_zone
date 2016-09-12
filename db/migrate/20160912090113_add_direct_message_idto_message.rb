class AddDirectMessageIdtoMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :direct_message_id, :string
  end
end
