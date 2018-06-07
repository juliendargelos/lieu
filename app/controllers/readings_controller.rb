class ReadingsController < ApplicationController
  authenticates! :user
  before_action :set_reading, only: [:show, :update]

  def show
    @book = @reading.book
    @chapters = @book.chapters
    @connecting = session.delete :reading_connecting
    @connecting = true # TODO: remove
  end

  def create
    @reading = Reading.new reading_params.merge!(user: current_user)
    @reading.connect!

    if @reading.save
      session[:reading_connecting] = true
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
    @reading = current_user.readings.find params[:id]
  end
end
