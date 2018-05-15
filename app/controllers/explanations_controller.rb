class ExplanationsController < ApplicationController
  authenticates! :user
  before_action :redirect_to_books_path, if: :tutorial_done

  def index

  end

  def tutorial_done
    current_user.tutorial_done
  end

  private

  def redirect_to_books_path
    redirect_to books_path
  end


end
