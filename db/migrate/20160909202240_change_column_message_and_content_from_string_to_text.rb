class ChangeColumnMessageAndContentFromStringToText < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :content, :text
    change_column :messages, :text, :text
  end
end
