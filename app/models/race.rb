class Race < ActiveRecord::Base
	belongs_to :meeting, foreign_key: "meetingId", primary_key: "meetingId"
	has_many :horses, foreign_key: "marketId", primary_key: "marketId"
	default_scope { order(time: :asc) }

	def pretty_time
		time.split("T").last.split(":")[0,2].join(":")
	end

	def past_cutoff_time?
		dif = (Time.parse(time) - Time.now.gmtime)/60 
		if dif < 15
			true
		else
			false
		end
	end

	def london_time
		(Time.parse(time)+(60*60)).to_s.split(" ")[1].split(":")[0..1].join(":")
	end

	def adelaide_time
		Time.zone = "Adelaide"
		the_time = Time.zone.parse(time)
		the_time.to_s.split(" ")[1..-2].first.split(":")[0..-2].join(":")
	end

	def update_odds
		wid = william_hill_id
		if wid
			doc = william_hill_feed
			odds = doc.xpath("//event[@id='#{wid}']/*")
			odds.each do |odd_node|
				horse = horses.where(order: odd_node.values.first).first
				horse.update(william_hill_odds: odd_node.text())
			end
		end
	end

  	def last_updated
  		dif = Time.parse("#{horses.first.updated_at} UTC")-Time.now.gmtime
  		if dif/60 < -60
  			return "#{(-dif/3600).round(0)} hrs ago"
  		elsif dif/60 < 0
  			return "#{(-dif/60).round(0)} mins ago" 
  		elsif dif/60 < 60
  			return "#{(dif/60).round(0)} mins"
  		else
  			return "#{(dif/3600).round(0)} hrs"
  		end
  	end

	def william_hill_feed
		require 'open-uri'
		@feed ||= Nokogiri::HTML(open("https://www.williamhill.com.au/XMLFeeds/secure/racing/XMLRaceDayFixedFeed.xml"))
	end

	def get_odds
		require 'open-uri'
		doc = Nokogiri::HTML(open("https://www.oddschecker.com/horse-racing/#{meeting.oddschecker_url}/#{london_time}/winner"))
		horses.each do |horse|
			path = "[translate(@data-bname, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='#{horse.name.downcase}']"
			will = doc.xpath("//tr#{path}/td[6]/@data-odig").first.value
			bet365 = doc.xpath("//tr#{path}/td[3]/@data-odig").first.value
			paddy = doc.xpath("//tr#{path}/td[10]/@data-odig").first.value
			skybet = doc.xpath("//tr#{path}/td[4]/@data-odig").first.value 
			ladbrokes = doc.xpath("//tr#{path}/td[13]/@data-odig").first.value 
			betvictor = doc.xpath("//tr#{path}/td[9]/@data-odig").first.value
			unibet = doc.xpath("//tr#{path}/td[11]/@data-odig").first.value
			sportingbet = doc.xpath("//tr#{path}/td[8]/@data-odig").first.value
			betfair = doc.xpath("//tr#{path}/td[17]/@data-odig").first.value
			coral = doc.xpath("//tr#{path}/td[14]/@data-odig").first.value
			horse.update(william_hill_odds: will, bet365_odds: bet365, paddy_power_odds: paddy, sky_bet_odds: skybet, ladbrokes_odds: ladbrokes, bet_victor_odds: betvictor, unibet_odds: unibet, sporting_bet_odds: sportingbet, betfair_odds: betfair, coral_odds: coral)
		end
	end

	def get_best_odds_id
		require 'open-uri'
		doc = Nokogiri::HTML(open("https://www.odds.com.au/horse-racing/#{race.meeting.oddschecker_url}"))
		better_matcher = "[translate(@data-bname, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='#{name.downcase}']"
		xpath = '//div[@class="competitor-info"]//*#{better_matcher}/parent::*/parent::*/parent::*/parent::*/parent::*/@id'
	end
end