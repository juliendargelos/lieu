class ChaptersController < ApplicationController
  authenticates! :user
  before_action :set_book

  def index
    @chapters = @book.chapters
  end

  private

  def set_book
    @book = Book.find params[:book_id]
  end
end
