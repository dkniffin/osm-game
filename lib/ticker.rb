require_relative '../app/services/zombie_spawner'

class Ticker
  include Singleton

  TICK_TIME = 0.1.seconds

  def initialize
    Character.connection
    @spawner = ZombieSpawner.new
  end

  def run
    tick_count = 0
    every_tick do
      tick_count += 1
      Character.all.each { |c| c.tick(tick_count) }
      # @spawner.spawn
      Zombie.all.each { |z| z.tick(tick_count) }
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
