class ReadingsController < ApplicationController
  authenticates! :user
  before_action :set_reading, only: [:show, :update]

  def show
    @book = @reading.book
    @chapters = @book.chapters
  end

  def create
    @reading = Reading.new reading_params.merge!(user: current_user)

    if @reading.save
      redirect_to @reading
    else
      redirect_to books_path
    end
  end

  def update
    @reading.update reading_params
    head :ok
  end

  private

  def reading_params
    params.require(:reading).permit :chapter_id
  end

  def set_reading
    @reading = Reading.find params[:id]
  end
end
