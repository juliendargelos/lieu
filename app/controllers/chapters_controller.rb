class ChaptersController < ApplicationController
  authenticates! :user
  before_action :set_book, only: :index
  before_action :set_chapter, only: :show

  def index
    @chapters = @book.chapters
    @books = Book.all
  end

  def show
    render json: {
      image: current_user.readings.for(@chapter.book).draws.for(@chapter).try(:image).try(:url)
    }
  end

  private

  def set_book
    @book = Book.find params[:book_id]
  end

  def set_chapter
    @chapter = Chapter.find params[:id]
  end
end
