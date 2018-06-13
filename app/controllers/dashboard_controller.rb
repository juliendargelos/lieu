class DashboardController < ApplicationController
  authenticates! :user
  before_action :redirect_to_books_path , unless: :current_user_reading?

  def show
    @reading = current_user.reading
  end
end
