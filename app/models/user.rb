class User < ActiveRecord::Base
	has_secure_password
	has_many :tips
	validates_presence_of :username,:email
	validates_uniqueness_of :username, :email


	def todays_tips
		tips.where("DATE(created_at) = ?", Date.parse(Time.new.gmtime.to_s))
	end
	def todays_unsent_tips
		todays_tips.reject{|x| x.sent == true} 
	end


	def todays_sent_tips
		todays_tips.reject{|x| x.sent == false} 
	end

	def send_tips
		todays_unsent_tips.each do |tip|
			if !tip.past_cutoff_time?
				tip.update(sent: true)
				tip.fifteen_minutes_odds
				tip.thirty_minutes_odds
			else
				tip.delete
			end
		end
	end
end