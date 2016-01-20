class Api::CharactersController < ActionController::Base
  before_action :set_character, only: [:show]

  respond_to :json

  def show
    render json: @character
  end

  private

  def set_character
    @design = Character.find(params[:id])
  end
end
