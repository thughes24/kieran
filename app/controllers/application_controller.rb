class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in, :logged_in_only,:logged_out_only

  def current_user
  	if session[:user_id]
  		@current_user ||= User.find(session[:user_id])
  	else
  		@current_user = nil
  	end
  end

  def logged_in
  	!!current_user
  end

  def logged_in_only
  	if logged_in
  		#proceed peacefully
  	else
  		flash[:notice] = "You need to be logged in for that."
  		redirect_to root_path
  	end
  end

  def logged_out_only
  	if logged_in
  		redirect_to tips_path
  	else
  		#proceed peacefully
  	end
  end
end
