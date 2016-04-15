App.characters = App.cable.subscriptions.create "CharactersChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    Character.upsert(id, character) for id, character of data

  move: (id, latlng) ->
    @perform("move", {id: id, lat: latlng['lat'], lon: latlng['lng']})

  search: (id, latlng) ->
    @perform("search", {id: id, lat: latlng['lat'], lon: latlng['lng']})

  use_item: (character_id, item_id) ->
    @perform("use_item", {id: character_id, item_id: item_id})

  equip_item: (character_id, item_id) ->
    @perform("equip_item", {id: character_id, item_id: item_id})

  unequip_item: (character_id, item_id) ->
    @perform("unequip_item", {id: character_id, item_id: item_id})

  take_damage: (id, d = 5) ->
    @perform("take_damage", {id: id, damage: d})

  restore_health: (id, h = 5) ->
    @perform("restore_health", {id: id, health: h})

  restore_food: (id, h = 5) ->
    @perform("restore_food", {id: id, health: h})

  lose_food: (id, d = 5) ->
    @perform("lose_food", {id: id, damage: d})

  restore_water: (id, h = 5) ->
    @perform("restore_water", {id: id, health: h})

  lose_water: (id, d = 5) ->
    @perform("lose_water", {id: id, damage: d})
