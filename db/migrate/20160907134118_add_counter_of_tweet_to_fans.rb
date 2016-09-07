class AddCounterOfTweetToFans < ActiveRecord::Migration[5.0]
  def change
    add_column :fans, :counter_of_tweet, :integer, default: 0
  end
end
