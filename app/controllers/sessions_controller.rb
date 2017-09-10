class SessionsController < ApplicationController

	def create
		@user = User.find_by(username: params[:username])
		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			redirect_to tips_path
		else
			flash[:error] = "Invalid Username/Password"
			@user = User.new
			@title = "Home"
			render '/home/index'
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end
end