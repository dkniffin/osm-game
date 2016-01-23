require_relative '../ticker'
namespace :ticker do
  desc "Runs the server tick"
  task run: :environment do
    Ticker.instance.run
  end
end
