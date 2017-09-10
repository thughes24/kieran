class AddTimesToTips < ActiveRecord::Migration[5.1]
  def change
  	add_column :tips, :average_odds_15, :string
  	add_column :tips, :average_odds_30, :string
  end
end
