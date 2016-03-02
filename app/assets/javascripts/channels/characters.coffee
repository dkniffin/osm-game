App.game = {}

class Character

  DESELECTED_OPACITY = 0.7
  SELECTED_OPACITY = 1.0
  @_characters: {}

  @get: (id) ->
    @_characters[id]

  @upsert: (id, data) ->
    if @_characters[id] == undefined
      console.debug('making new character')
      @_characters[id] = new Character(data)
    else
      @_characters[id].update(data)
    @_characters[id]

  constructor: (@data) ->
    @marker = L.marker([@data['lat'], @data['lon']],
      {icon: App.icons.characterIcon, opacity: DESELECTED_OPACITY})
    @marker.on('click', @select.bind(this))
    @marker.addTo(App.map)

  update: (data) ->
    @marker.setLatLng([data['lat'], data['lon']])
    @data = data

  select: (e) ->
    App.game.selected = this
    @marker.setOpacity(SELECTED_OPACITY)

  unselect: (e) ->
    App.game.selected = null
    @marker.setOpacity(DESELECTED_OPACITY)

App.characters = App.cable.subscriptions.create "CharactersChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    Character.upsert(id, character) for id, character of data

  move: (id, latlng) ->
    @perform("move", {id: id, lat: latlng['lat'], lon: latlng['lng']})
