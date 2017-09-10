class AddSentToTips < ActiveRecord::Migration[5.1]
  def change
  	add_column :tips, :sent, :boolean
  end
end
