class ChaptersController < ApplicationController
  authenticates! :user

  def index
    @chapters = Chapter.all
  end

end
