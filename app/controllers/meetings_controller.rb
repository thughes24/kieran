class MeetingsController < ApplicationController
	def show
		@meetings = Meeting.all
		@current_race = Meeting.find(params[:id]).races.first
		@tips = Tip.all.where(user_id: current_user.id)
		respond_to do |format|
			format.js{render '/shared/ajax_meeting'}
		end
	end
end