# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class CharactersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "characters"
  end

  def move(data)
    character = Character.find(data[:id])
    character.move(data[:lat], data[:lon])
  end
end
