class TipsController < ApplicationController
	before_action :logged_in_only, only: [:create,:destroy]

	def index
		@title = "Enter Tips"
		@meetings = Meeting.all
		@meeting = params[:meeting] ? params[:meeting] : Meeting.first.name
		@race = params[:race] ? params[:race] : Meeting.where(name: @meeting).first.races.first.time
		@current_race = Race.where(time: @race).first
		@tips = logged_in ? Tip.todays : []
		respond_to do |format|
			format.html
			format.js{@tips = Tip.todays; render '/shared/ajax_race'}
		end
	end

	def create
		hors = Horse.find(params[:id])
		@current_race = Race.find(params[:current_race])
		@hors = hors
		tip = Tip.new(selectionId: hors.selectionId,name: hors.name,order: hors.order,marketId: hors.marketId,meetingId: hors.meetingId, meeting_name: hors.race.meeting.name, race_time: hors.race.time, user_id: current_user.id, average_odds: 0, image: hors.image)
		if tip.valid?
			tip.save!
		elsif !Tip.where(selectionId: hors.selectionId, user_id: current_user.id).first.sent?
			Tip.all.where(selectionId: hors.selectionId, marketId: hors.marketId, user_id: current_user.id).first.delete
		end
		@tips = Tip.todays
		respond_to do |format|
			format.html
			format.js{ render '/shared/ajax_tips_race'}
		end
	end

	def destroy
		@current_race = Race.find(params[:current_race])
		@tip = Tip.find(params[:id])
		@tip.destroy
		respond_to do |format|
			format.html
			format.js{@tips = Tip.todays; render '/shared/ajax_tips_race'}
		end
	end

	def update

	end
end