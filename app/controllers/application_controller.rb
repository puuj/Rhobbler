class ApplicationController < ActionController::Base
  protect_from_forgery

private
  def set_current_user(a_user)
    if a_user.is_a?(User)
      session[:user_id] = a_user.id
      @current_user = a_user
    elsif a_user.is_a?(Fixnum)
      session[:user_id] = a_user
    end
  end

  def current_user
    return @current_user if @current_user || session[:user_id].nil?
    @current_user = User.find(session[:user_id])
  end
end
