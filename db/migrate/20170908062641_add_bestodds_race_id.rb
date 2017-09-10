class AddBestoddsRaceId < ActiveRecord::Migration[5.1]
  def change
  	add_column :races, :best_odds_id, :string
  	remove_column :races, :william_hill_id
  end
end
