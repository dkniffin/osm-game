# Be sure to restart your server when you modify this file. Action Cable runs in an EventMachine loop that does not support auto reloading.
class CharactersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "characters"
  end

  def move(data)
    character(data).move(data['lat'], data['lon'])
  end

  def restore_health(data)
    character(data).restore_health(data['health'])
  end

  def take_damage(data)
    character(data).take_damage(data['damage'])
  end

  def restore_food(data)
    character(data).restore_food(data['health'])
  end

  def lose_food(data)
    character(data).lose_food(data['damage'])
  end

  private

  def character(data)
    Character.find(data['id'])
  end
end
