class ChangeIntToStringFromPosts < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :tweet_id, :string
    change_column :posts, :fan_id, :string
  end
end
