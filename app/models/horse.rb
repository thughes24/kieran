class Horse < ActiveRecord::Base
	belongs_to :race, foreign_key: "marketId", primary_key: "marketId"
	default_scope { order(order: :asc) }

	def best_odds
		oa ={"William Hill" => william_hill_odds, "Bet365" => bet365_odds, "PaddyPower" => paddy_power_odds, "Skybet" => sky_bet_odds, "Ladbrokes" => ladbrokes_odds, "Betvictor" => bet_victor_odds, "Unibet" => unibet_odds, "Sporting Bet" => sporting_bet_odds, "Betfair" => betfair_odds, "Coral" => coral_odds}.delete_if { |k, v| v.blank? }
		best = oa.max_by{|k,v| v}[1] if oa.count > 0
	end

	def best_odds_agency
		oa ={"William Hill" => william_hill_odds, "Bet365" => bet365_odds, "PaddyPower" => paddy_power_odds, "Skybet" => sky_bet_odds, "Ladbrokes" => ladbrokes_odds, "Betvictor" => bet_victor_odds, "Unibet" => unibet_odds, "Sporting Bet" => sporting_bet_odds, "Betfair" => betfair_odds, "Coral" => coral_odds}.delete_if { |k, v| v.blank? }
		best = oa.max_by{|k,v| v}[0] if oa.count > 0 
	end

	#def average_odds
	#	oa ={"William Hill" => william_hill_odds, "Bet365" => bet365_odds, "PaddyPower" => paddy_power_odds, "Skybet" => sky_bet_odds, "Ladbrokes" => ladbrokes_odds, "Betvictor" => bet_victor_odds, "Unibet" => unibet_odds, "Sporting Bet" => sporting_bet_odds, "Betfair" => betfair_odds, "Coral" => coral_odds}.delete_if { |k, v| v.blank? || v.empty? }
	#	oa.reject{|k,v| v=="0"}
	#	oa.values.map(&:to_f).reduce(:+)/oa.values.size
	#end
end