class AddOddsToHorses < ActiveRecord::Migration[5.1]
  def change
  	add_column :horses, :bet365_odds, :string
  	add_column :horses, :paddy_power_odds, :string
  	add_column :horses, :sky_bet_odds, :string
  	add_column :horses, :ladbrokes_odds, :string
  	add_column :horses, :bet_victor_odds, :string
  	add_column :horses, :unibet_odds, :string
  	add_column :horses, :sporting_bet_odds, :string
  	add_column :horses, :betfair_odds, :string
  	add_column :horses, :coral_odds, :string
  end
end
