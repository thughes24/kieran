class AddAusBookies < ActiveRecord::Migration[5.1]
  def change
  	add_column :horses, :crownbet_odds, :string
  	add_column :horses, :palmerbet_odds, :string
  	add_column :horses, :luxbet_odds, :string
  	add_column :horses, :sportsbet_odds, :string
  	add_column :horses, :best_odds_id, :string
  end
end
