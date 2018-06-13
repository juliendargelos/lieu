class ExplanationsController < ApplicationController
  authenticates! :user
  skip_before_action :redirect_to_explanations_path
  skip_before_action :redirect_to_new_avatar_path
  before_action :redirect_to_books_path, if: :tutorial_done?

  def show

  end

  private

  def tutorial_done?
    current_user.tutorial_done
  end
end
