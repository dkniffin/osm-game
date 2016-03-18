require_relative '../app/services/zombie_spawner'

class Ticker
  include Singleton

  TICK_TIME = 0.1.seconds

  def initialize
    Character.connection
    @spawner = ZombieSpawner.new
  end

  def run
    every_tick do
      Character.all.each { |c| c.tick }
      # @spawner.spawn
      Zombie.all.each { |z| z.tick }
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
end
