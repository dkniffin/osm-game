App.game = {}

class Character

  DESELECTED_OPACITY = 0.7
  SELECTED_OPACITY = 1.0
  @_characters: {}

  @sidebarSection = $('.sidebar .sidebar__character')

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
      {icon: @_characterIcon(@data['health']), opacity: DESELECTED_OPACITY})
    @marker.on('click', @select.bind(this))
    @marker.addTo(App.map)

  update: (data) ->
    @marker.setIcon(@_characterIcon(data.health))
    @marker.setLatLng([data['lat'], data['lon']])
    @data = data
    $('.header .health .value').html(data.health)
    $('.header .food .value').html(data.food)

  select: (e) ->
    App.game.selected = this
    @marker.setOpacity(SELECTED_OPACITY)
    @_updateSidebar()

  unselect: (e) ->
    App.game.selected = null
    @marker.setOpacity(DESELECTED_OPACITY)
    @_hideSidebar()

  _updateSidebar: ->
    sidebar = $('.sidebar .sidebar__character')
    sidebar.children('.name').html(@data.name)
    sidebar.show()

  _hideSidebar: ->
    sidebar = $('.sidebar .sidebar__character')
    sidebar.hide()

  _characterIcon: (health) ->
    L.divIcon({
      className: 'character-icon'
      iconSize:     [48, 48]
      iconAnchor:   [12, 12]
      html: "#{@_healthBarHTML(health)}"
    })

  _healthBarHTML: (health) ->
    "<progress value=#{health} max=100 />"

App.characters = App.cable.subscriptions.create "CharactersChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    Character.upsert(id, character) for id, character of data

  move: (id, latlng) ->
    @perform("move", {id: id, lat: latlng['lat'], lon: latlng['lng']})

  take_damage: (id, d = 5) ->
    @perform("take_damage", {id: id, damage: d})

  restore_health: (id, h = 5) ->
    @perform("restore_health", {id: id, health: h})

  restore_food: (id, h = 5) ->
    @perform("restore_food", {id: id, health: h})

  lose_food: (id, d = 5) ->
    @perform("lose_food", {id: id, damage: d})
