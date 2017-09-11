class Tip < ActiveRecord::Base
	belongs_to :user
	belongs_to :race, foreign_key: "marketId", primary_key: "marketId", optional: true
	validates_uniqueness_of :user_id, scope: [:selectionId, :marketId], on: :create
	default_scope { order(race_time: :asc) }

	def pretty_time
		race_time.split("T").last.split(":")[0,2].join(":")
	end

	def adelaide_time
		Time.zone = "Adelaide"
		time = Time.zone.parse(race_time)
		time.to_s.split(" ")[1..-2].first.split(":")[0..-2].join(":")
	end

	def london_time
		(Time.parse(race_time)+(60*60)).to_s.split(" ")[1].split(":")[0..1].join(":")
	end

	def self.todays
		where("DATE(race_time) = ?", Date.parse(Time.new.gmtime.to_s))
	end

  	def time_to
  		dif = Time.parse("#{race_time} UTC")-Time.now.gmtime
  		if dif/60 < -60
  			return "(#{(-dif/3600).round(0)} hrs ago)"
  		elsif dif/60 < 0
  			return "(#{(-dif/60).round(0)} mins ago)" 
  		elsif dif/60 < 60
  			return "(#{(dif/60).round(0)} mins)"
  		else
  			return "(#{(dif/3600).round(0)} hrs)"
  		end
  	end

	def past_cutoff_time?
		dif = (Time.parse(race_time) - Time.now.gmtime)/60 
		if dif < 15
			true
		else
			false
		end
	end

	def fifteen_minutes_odds 
		horse = Horse.find_by(selectionId: selectionId)
		if (Time.parse(horse.updated_at.to_s) - Time.now.gmtime)/60 < 5
			update(average_odds_15: horse.average_odds)
		else
			horse.race.meeting.get_aus_odds
			update(average_odds_15: horse.reload.average_odds)
		end
	end
	handle_asynchronously :fifteen_minutes_odds, :run_at => Proc.new { 15.minutes.from_now }

	def thirty_minutes_odds
		horse = Horse.find_by(selectionId: selectionId)
		if (Time.parse(horse.updated_at.to_s) - Time.now.gmtime)/60 < 5
			update(average_odds_30: horse.average_odds)
		else
			horse.race.meeting.get_aus_odds
			update(average_odds_30: horse.reload.average_odds)
		end
	end
	handle_asynchronously :thirty_minutes_odds, :run_at => Proc.new { 30.minutes.from_now }

	def resulted?
		(Time.parse(race_time.to_s) - Time.now.gmtime)/60 < -10 ? true : false
	end

end