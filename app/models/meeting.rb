class Meeting < ActiveRecord::Base
	has_many :races, foreign_key: "meetingId", primary_key: "meetingId"

	def get_oddschecker_url
		meeting_urls = oddschecker_meetings_page.xpath('//div[@class="module show-times"]//a[@class="venue"]/@href').each_with_object([]) do |x,obj|
			obj << x.value.split("/")[2..-1].flatten
		end.flatten!
		min = meeting_urls.map{|x| [Levenshtein.distance(x,name.downcase),x]}.min
		update(oddschecker_url: min[1]) if min[0] < 4
	end

	def get_bestodds_url
		require 'open-uri'
		doc = Nokogiri::HTML(open('https://www.odds.com.au/racing/'))
		xpath = '//table[@class="upcoming-races"][1]//td//img[@alt="Australia Flag"]/parent::*/parent::*//a/@href'
		raw_urls = doc.xpath(xpath)
		refined_urls = raw_urls.map{|x| x.value.split("/")[2..-2]}.uniq.flatten.compact
		min = refined_urls.map{|x| [Levenshtein.distance(x.split("-").first,name.downcase.split(" ").first),x]}.min
		update(oddschecker_url: min[1]) if min[0] < 4
	end

	def get_bestodds_ids
		require 'open-uri'
		doc = Nokogiri::HTML(open("https://www.odds.com.au/horse-racing/#{oddschecker_url}"))
		races.each do |race|
			race.horses.each do |horse|
				nm = horse.name.upcase.split('.').last.strip
				better_matcher = "[contains(translate(text(),#{%q("abcdefghijklmnopqrstuvwxyz'")},'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),'#{nm}')]"
				xpath = "//div[@class='competitor-info ']//*#{better_matcher}/parent::*/parent::*/parent::*/parent::*/parent::*/@id"
				filtered = doc.xpath(xpath).first
				if filtered && race.best_odds_id.blank?
					race_id = filtered.parent.parent.parent.attribute("data-event").value
					race.update(best_odds_id: race_id)
				end
				hid = filtered.value.split('_').last if filtered
				horse.update(best_odds_id: hid)
			end
		end
	end

	def get_aus_odds
		require 'open-uri'
		doc = Nokogiri::HTML(open("https://www.odds.com.au/horse-racing/#{oddschecker_url}"))
		races.each_with_index do |race, i|
			race.horses.reject{|x| x.best_odds_id.blank? }.each do |horse|
				xpath = "//div[@class='component-wrapper odds-comparison-full-width' and contains(@data-api-params,'#{race.best_odds_id}')]//div[@id='ocSelection_#{horse.best_odds_id}' and @class='oc-table-tr gutter']"
				eek = doc.xpath(xpath)

				if eek.xpath("*[contains(@class,'ladbrokes-line')]").first
					ladbrokes = eek.xpath("*[contains(@class,'ladbrokes-line')]").first.text.strip.split("bet").last
					bet365 = eek.xpath("*[contains(@class,'bet365-line')]").first.text.strip.split("bet").last
					sportsbet = eek.xpath("*[contains(@class,'sportsbet-line')]").first.text.strip.split("bet").last
					unibet = eek.xpath("*[contains(@class,'unibet-line')]").first.text.strip.split("bet").last
					palmerbet = eek.xpath("*[contains(@class,'palmerbet-line')]").first.text.strip.split("bet").last
					crownbet = eek.xpath("*[contains(@class,'crownbet-line')]").first.text.strip.split("bet").last
					williamhill = eek.xpath("*[contains(@class,'williamhill-line')]").first.text.strip.split("bet").last
					luxbet = eek.xpath("*[contains(@class,'luxbet-line')]").first.text.strip.split("bet").last
					horse.update(ladbrokes_odds: ladbrokes, bet365_odds: bet365, sportsbet_odds: sportsbet, unibet_odds: unibet, palmerbet_odds: palmerbet, crownbet_odds: crownbet, william_hill_odds: williamhill, luxbet_odds: luxbet)
				end
			end
		end
	end

	def oddschecker_meetings_page
		require 'open-uri'
		@doc ||= Nokogiri::HTML(open("https://www.oddschecker.com/horse-racing"))
	end
end