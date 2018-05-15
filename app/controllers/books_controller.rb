class BooksController < ApplicationController
  authenticates! :user
  before_action :set_book, only: :show

  def index
    @books = Book.all
  end

  def show

  end

  protected

  def set_book
    @book = Book.published.find params[:id]
  end
end
