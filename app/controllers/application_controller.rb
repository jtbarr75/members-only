class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  #logs in the given user
  def log_in(user)
    user.remember
    user.save
    cookies.permanent[:remember_token] = user.remember_token
    current_user = user
  end

  #returns the current user
  def current_user
    if (remember_token = cookies[:remember_token])
      @current_user ||= User.find_by(remember_digest: User.digest(remember_token))
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    cookies.delete(:remember_token)
    current_user = nil
  end
end
