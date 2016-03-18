## Install

First, all the normal rails stuff:
````
cp config/secrets.example.yml config/secrets.yml
rake db:setup
````

Then, set up redis:
````
brew install redis
ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist
````

## Usage

In addition to the normal `rails s`, you also have to start the game ticker with `rake ticker:run`


## Getting set up with OSM data

1. In addition to Postgres, you'll need the postgis extension (for homebrew: `brew install postgis`)
1. Download data from [Mapzen](https://mapzen.com/data/metro-extracts/) or similar. You want either a `.osm` or `.pbf` file
1. Install osm2pgsql (For homebrew: `brew install osm2pgsql`)
1. Do the import: `osm2pgsql -s -l -d osm_game_development /path/to/osm_or_pbf`
