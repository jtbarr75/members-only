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

  #assigns current user
  def current_user=(user)
    @current_user = user
  end

  #returns true if user is logged in
  def logged_in?
    !current_user.nil?
  end

  #logs out current user
  def log_out
    cookies.delete(:remember_token)
    current_user = nil
  end

  #redirects if not logged in
  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  #redirects unless user page belongs to current user
  def correct_user
    user = User.find(params[:id])
    redirect_to root_url unless user == current_user
  end
end
