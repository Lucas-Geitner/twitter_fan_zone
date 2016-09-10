class ChangeSenderFromStringToTextOnMessage < ActiveRecord::Migration[5.0]
  def change
    change_column :messages, :sender, :text
  end
end
