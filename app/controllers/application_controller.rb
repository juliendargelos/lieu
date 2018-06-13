class ApplicationController < ActionController::Base
  authenticates(:user) { redirect_to new_user_authentication_path }
  unauthenticates(:user) { redirect_to explanations_path }
  before_action :redirect_to_explanations_path, unless: :current_user_tutorial_done?
  before_action :redirect_to_new_avatar_path, unless: :current_user_has_avatar?

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

  def redirect_to_dashboard_path
    redirect_to dashboard_path
  end

  def redirect_to_explanations_path
    redirect_to explanations_path
  end

  def redirect_to_books_path
    redirect_to books_path
  end

  def redirect_to_new_avatar_path
    redirect_to new_avatar_path
  end

  def current_user_reading?
    current_user.reading?
  end

  def current_user_has_avatar?
    current_user.blank? || current_user.has_avatar?
  end

  def current_user_tutorial_done?
    current_user.blank? || current_user.tutorial_done
  end
end
