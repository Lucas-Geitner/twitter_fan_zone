class AddImageMigrationToFans < ActiveRecord::Migration[5.0]
  def change
    add_column :fans, :image_url, :string
  end
end
