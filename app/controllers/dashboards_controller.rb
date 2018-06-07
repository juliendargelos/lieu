class DashboardsController < ApplicationController
  authenticates! :user

  def show
    redirect_to books_path and return unless current_user.reading?
  end
end
