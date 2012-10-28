class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :user_logged_in?
  helper_method :correct_user?

  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def user_logged_in?
      !!current_user
    end

    def correct_user?
      @user = User.find(params[:id])
      unless current_user == @user
        redirect_to root_url, alert: "Whoah, you're not allowed in there."
      end
    end

    def authenticate_user!
      unless user_logged_in?
        redirect_to root_url, alert: 'You need to be logged in to do that.'
      end
    end
end
