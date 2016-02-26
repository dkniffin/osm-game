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
