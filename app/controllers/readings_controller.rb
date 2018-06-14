class ReadingsController < ApplicationController
  authenticates! :user
  before_action :set_reading, only: [:show, :update]

  def show
    @connecting = session.delete :reading_connecting

    respond_to do |format|
      format.html
      format.json do
        response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'

        render json: @reading
      end
    end
  end

  def create
    @reading = Reading.new reading_params

    existing_reading = current_user.reading for: @reading.book
    redirect_to existing_reading and return if existing_reading.present?

    @reading.connect!

    if @reading.save
      session[:reading_connecting] = true
      redirect_to @reading
    else
      error 'Impossible de commencer cette lecture...'
      redirect_to books_path
    end
  end

  def update
    @reading.update reading_params
    head :ok
  end

  private

  def reading_params
    params
      .require(:reading)
      .permit(:chapter_id, :finished)
      .tap { |p| p.merge! user: current_user if action_name == 'create' }
  end

  def set_reading
    @reading = Reading.find params[:id]
  end
end
