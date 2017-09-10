class BetfairWrapper
	attr_reader :client, :discount
	def initialize(username=ENV["betfair_username"], password=ENV["betfair_password"])
		@client = Betfair::Client.new("X-Application" => ENV["betfair_app_key"])
		@client.interactive_login(username, password)
	end

	def logged_in?
		client.persistent_headers["X-Authentication"] == "" ? false : true
	end

	def todays_events
		Time.zone = "Adelaide"
		@todays_events ||= @client.list_market_catalogue({
			filter: {
				eventTypeIds: [7],
				marketTypeCodes: ["WIN"],
				marketCountries: ["GB", "IE"],
				marketStartTime: {
					from: Time.zone.parse(Time.zone.now.to_s).beginning_of_day.iso8601,
					to: Time.zone.parse(Time.zone.now.to_s).end_of_day.iso8601
				}
			},
			maxResults: 1000,
			marketProjection: [
    			"MARKET_START_TIME",
    			"RUNNER_DESCRIPTION",
    			"RUNNER_METADATA",
    			"EVENT"
 			]
		}) 
	end

	def meetings
		@meetings ||= todays_events.each_with_object([]) do |x,meeting|
  			meeting << [(x["event"]["venue"]),x["event"]["id"], x["event"]["countryCode"]]  
		end
		@meetings = @meetings.uniq{|x| x[0]}
		@meetings
	end

	def get_meetings_with_races
		meeting_w_races = meetings.each_with_object([]) do |y,obj|
  			meeting_id = y[1]  
  			temp = todays_events.map { |x| [x["marketStartTime"],[x["marketId"], x["marketName"]]] if x["event"]["id"] == meeting_id }.compact.to_h
  			#run = temp.values.each_with_object([]) do |x,ob|
  			#	ob << [x,get_runners(x)]
  			#end
  			#runhash = run.each_with_object({}) do |x,hsh|
  			#	hsh[x[0]] = x[1]
  			#end
			obj << [meeting_id,temp] 
  		end 
  		@hash = meeting_w_races.to_h.each_with_object({}) do |x,new_hash|
			new_hash[x[0]] = x[1]
		end
	end

	def get_meeting_id(meeting_name)
		meetings.map {|k,v| [Levenshtein.distance(k.split(" ").first,meeting_name),v]}.min[1]
	end

	def get_race_id(meeting_name,time)
		get_meetings_with_races[get_meeting_id(meeting_name)][BetfairWrapper.convert_iso_to_military(time)]
	end

	def get_runners(race_id)
		todays_events.map {|x| x["runners"] if x["marketId"] == race_id }.compact.flatten
	end

	def get_race_names(meeting_id)
		todays_events.map {|x| x["marketName"] if x["event"]["id"] == meeting_id}.compact
	end

	def trotters?(meeting_id)
		get_race_names(meeting_id).first.include?("Trot M") || get_race_names(meeting_id).first.include?("Pace M")
	end

	def get_selection_id(meeting_name,time,horse)
		@horse = horse
		@x = get_runners(get_race_id(meeting_name,time))
		@y = @x.map { |x| [Levenshtein.distance(x["runnerName"],@horse),x["selectionId"],x["runnerName"]]}
		@min = @y.min[1]
		@min
	end

	def get_sp(bet)
		market_book = client.list_market_book({
			marketIds: [bet.marketId],
			selectionIds: [bet.selectionId],
			priceProjection: {
				priceData: ["SP_AVAILABLE"]
			}
		})
		runners = market_book[0]["runners"]
		sp = runners.each_with_object([]) do |x,obj|
		  obj << x["sp"]["actualSP"] if x["selectionId"] == bet.selectionId.to_i   
		end
		return sp[0]
	end

	def get_result(bet)
		market_book = client.list_market_book({
			marketIds: [bet.marketId],
			selectionIds: [bet.selectionId],
			priceProjection: {
				priceData: ["SP_AVAILABLE"]
			}
		})
		runners = market_book[0]["runners"]
		result = runners.each_with_object([]) do |x,obj|
		  obj << x["status"] if x["selectionId"] == bet.selectionId.to_i   
		end
		return result[0]
	end

	def deduction_factor(bet)
		if bet.result == "SCRATCHED" || bet.result.blank?
			0.0
		else
			book = client.list_market_book(marketIds: [bet.marketId])
			non_runners = book.first["runners"].reject{|x| x["status"]!= "REMOVED"}
			scratched_after_placing = non_runners.reject{|x| x["removalDate"] < bet.created_at }.reject{|x| x["adjustmentFactor"].to_f < 2.5}
			if scratched_after_placing.count > 0
				deduction_factor = scratched_after_placing.map{|x| x["adjustmentFactor"]}.map(&:to_f).inject(:+).round(2)
			else
				0.0
			end
		end
	end
end