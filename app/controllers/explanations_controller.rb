class ExplanationsController < ApplicationController
  authenticates! :user
  before_action :set_user

  def index

  end

  protected

  def set_user
    @user = current_user
  end

end
