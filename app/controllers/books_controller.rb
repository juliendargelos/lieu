class BooksController < ApplicationController

  before_action :set_book, only: [:show]

  def index
    @books = Book.all
  end

  def show
  end

  protected

  def set_book
    @book = Book.find params[:id]
  end

  def book_params
    params.require(:book).permit(:title, :author, :summary, :number_of_chapters)
  end

end
