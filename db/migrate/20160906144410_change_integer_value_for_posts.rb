class ChangeIntegerValueForPosts < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :tweet_id, :bigint, limit: 10
    # add_column :yourtable, :duration, :integer, :limit => 8

  end
end
