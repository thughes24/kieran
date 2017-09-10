class HomeController < ApplicationController
	before_action :logged_out_only
	def index
		@title = "Home"
		@user = User.new
	end
end