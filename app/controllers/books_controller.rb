class BooksController < ApplicationController
  authenticates! :user
  before_action :set_book, only: :show

  def index
    redirect_to dashboard_path and return if current_user.reading?
    @books = Book.all
  end

  def show

  end

  protected

  def set_book
    @book = Book.published.find params[:id]
  end
end
