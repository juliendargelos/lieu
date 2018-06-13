class BooksController < ApplicationController
  authenticates! :user
  before_action :redirect_to_dashboard_path, if: :current_user_reading?

  def index
    @books = Book.all
  end
end
