class ApplicationController < ActionController::Base
  authenticates(:user) { redirect_to new_user_authentication_path }
  unauthenticates(:user) { redirect_to explanations_path }

  protected

  def current_user
    User::Authentication.current.user
  end
  helper_method :current_user

  def current_user=(v)
    User::Authentication.current = User::Authentication.new user: v
  end

  def notifications(keep: false)
    notifications = (session[:notifications] ||= [])
    session.delete :notifications unless keep
    notifications.map! &:symbolize_keys!
  end
  helper_method :notifications

  def notificate(type, message)
    notifications(keep: true).push type: :"#{type}", message: message
  end

  [:success, :info, :error].each do |type|
    define_method(type) { |message| notificate type, message }
  end
end
