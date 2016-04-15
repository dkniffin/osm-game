App.zombies = App.cable.subscriptions.create "ZombiesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    Zombie.upsert(id, zombie) for id, zombie of data
