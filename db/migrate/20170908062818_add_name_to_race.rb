class AddNameToRace < ActiveRecord::Migration[5.1]
  def change
  	add_column :races, :best_odds_name, :string
  end
end
