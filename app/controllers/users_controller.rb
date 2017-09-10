class UsersController < ApplicationController
	
	def new
		@title = "Create Account"
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
		@title = @user.username.capitalize
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:notice] = "Account Successfully Created."
			session[:user_id] = @user.id
			redirect_to tips_path
		else
			flash[:error] = "no dice sunny, account was not made."
			render '/home/index'
		end
	end

	def send_tips
		@user = User.find(params[:id])
		@user.send_tips
		redirect_to user_path(@user)
	end

	def user_params
		params.require(:user).permit(:username, :password, :email)
	end
end