require_relative '../app/services/zombie_spawner'

class Ticker
  include Singleton

  TICK_TIME = 0.1.seconds

  def initialize
    Character.connection
  end

  def run
    puts "Running."
    tick_count = 0
    every_tick do
      puts "Tick: #{tick_count}" if tick_count % 100 == 0
      tick_count += 1
      tick_model(Character, CharacterTicker, tick_count)
      tick_model(Zombie, ZombieTicker, tick_count)
    end
  end

  private

  def every_tick
    last = Time.now
    while true
      yield
      now = Time.now
      _next = [last + TICK_TIME,now].max
      sleep (_next-now)
      last = _next
    end
  end

  def tick_model(model, ticker, tick_count)
    model.all.each do |obj|
      ticker.run!(subject: obj, tick_count: tick_count)
      if obj.changed?
        obj.save
      end
    end
  end
end
