task :clear => :environment do
	Meeting.delete_all
	Race.delete_all
	Horse.delete_all
end

task :pull_meetings => :environment do
	b = BetfairWrapper.new
	meetings = b.meetings
	meetings.each do |meeting|
		Meeting.create(name: meeting[0], meetingId: meeting[1], country: meeting[2])
	end
	Meeting.where('country != ?', "AU").each do |meeting|
		meeting.get_oddschecker_url
	end	
end

task :pull_races => :environment do
	b = BetfairWrapper.new
	races = b.get_meetings_with_races.each do |x|
		meetingId = x[0]
		x[1].each do |races|
			r = Race.new(meetingId: meetingId.to_s, marketId: races[1][0], time: races[0], name: races[1][1])
			r.save
		end
	end
end

task :pull_horses => :environment do
	b = BetfairWrapper.new
	Race.all.each do |x|
		b.get_runners(x.marketId).each do |horse|
			Horse.create(name: horse["runnerName"],selectionId: horse["selectionId"], marketId: x.marketId, meetingId: x.meetingId, order: horse["sortPriority"], days_since_last_run: horse["metadata"]["DAYS_SINCE_LAST_RUN"],form: horse["metadata"]["FORM"],jockey: horse["metadata"]["JOCKEY_NAME"], trainer: horse["metadata"]["TRAINER_NAME"], stall_draw: horse["metadata"]["STALL_DRAW"], sex: horse["metadata"]["SEX_TYPE"], image: horse["metadata"]["COLOURS_FILENAME"])
		end
	end
end

task :get_uk_odds => :environment do
	Meeting.where('country != ?', "AU").each do |meeting|
		meeting.races.each do |race|
			race.get_odds
		end
	end
end

task :pull_all => [:clear, :pull_meetings,:pull_races,:pull_horses]




