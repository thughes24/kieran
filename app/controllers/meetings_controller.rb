class MeetingsController < ApplicationController
	def show
		@meetings = Meeting.all
		@current_race = Meeting.find(params[:id]).races.first
		@tips = Tip.todays
		respond_to do |format|
			format.js{render '/shared/ajax_meeting_race'}
		end
	end
end