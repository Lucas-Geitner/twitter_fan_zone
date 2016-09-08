class AddContentandAndUrlToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :content, :string
    add_column :posts, :url_post, :string
    add_column :fans, :url_fan, :string
    add_column :fans, :follow, :boolean
  end
end
