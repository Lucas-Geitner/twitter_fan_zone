class ChangeIntegerValueofPostForFans < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :fan_id, :bigint, limit: 8
  end
end
