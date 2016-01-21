class CharactersController < WebsocketRails::BaseController
  def get
    puts "BLAH"
    trigger_success character
  end

  private

  def character
    @character ||= Character.find(message[:id])
  end
end
