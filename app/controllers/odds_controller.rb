class OddsController < ApplicationController
	def refresh_odds
		@current_race = Race.find(params[:id])
		if @current_race.meeting.country == "AU"
			@current_race.meeting.get_aus_odds
		else
			@current_race.get_odds
		end
		respond_to do |format|
			format.js{render '/shared/ajax_race'}
		end
	end
end