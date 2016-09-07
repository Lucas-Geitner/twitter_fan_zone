class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :tweet_id
      t.string :tweeter_user_id
      t.references :fan, foreign_key: true

      t.timestamps
    end
  end
end
