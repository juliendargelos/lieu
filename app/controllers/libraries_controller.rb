class LibrariesController < ApplicationController
  
  def index
    @books = Book.all
  end

end
