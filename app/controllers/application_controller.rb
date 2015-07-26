class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= begin
      session[:user_id].present? && User.find_by(id: session[:user_id])
    end
  end
  helper_method :current_user

end
