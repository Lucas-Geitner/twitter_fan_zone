class CreateFans < ActiveRecord::Migration[5.0]
  def change
    create_table :fans do |t|
      t.string :name
      t.string :category
      t.string :contact

      t.timestamps
    end
  end
end
