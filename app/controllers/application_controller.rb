class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :setup_character

  def main
    render 'game/main'
  end

  def threeD
    render 'game/3d'
  end

  private

  def setup_character
    @character = Character.first
  end
end
