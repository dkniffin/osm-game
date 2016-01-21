class CharactersController < WebsocketRails::BaseController
  def get
    trigger_success @character
  end

  def all
    trigger_success Character.all
  end

  private

  def character
    @character ||= Character.find(message[:id])
  end
end
