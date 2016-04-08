App.game = {}

class window.Character

  DESELECTED_OPACITY = 0.7
  SELECTED_OPACITY = 1.0
  @_characters: {}

  @sidebarSection = $('.sidebar .sidebar__character')

  @get: (id) ->
    @_characters[id]

  @upsert: (id, data) ->
    data = JSON.parse(data)
    if @_characters[id] == undefined
      console.debug('making new character')
      @_characters[id] = new Character(data)
    else
      @_characters[id].update(data)
    @_characters[id]

  constructor: (@data) ->
    # @marker = L.marker([@data['lat'], @data['lon']],
      # {icon: @_characterIcon(@data['health']), opacity: DESELECTED_OPACITY})
    @model = App.osmb.addOBJ(App.models.character,
      { latitude: @data['lat'], longitude: @data['lon'] },
      { id: "character_#{@data['id']}", color: 'tan'})
    # @marker.on('click', @select.bind(this))
    # @marker.addTo(App.map)

  update: (data) ->
    @data = data
    # @marker.setIcon(@_characterIcon(data.health))
    # @marker.setLatLng([data['lat'], data['lon']])
    @model.position = {latitude: data['lat'], longitude: data['lon']}
    $('.header .health .value').html(data.health)
    $('.header .food .value').html(data.food)
    $('.header .water .value').html(data.water)
    if App.game.selected == this
      @_updateSidebar()

  select: (e) ->
    App.game.selected = this
    # @marker.setOpacity(SELECTED_OPACITY)
    App.game.current_action = 'move'
    @_updateSidebar()

  unselect: (e) ->
    App.game.selected = null
    # @marker.setOpacity(DESELECTED_OPACITY)
    App.osmb.highlight(@data['id'])
    App.game.current_action = null
    @_hideSidebar()

  _updateSidebar: ->
    sidebar = $('.sidebar .sidebar__character')
    sidebar.find('.name').html(@data.name)
    sidebar.find('.health').html(@data.health)
    sidebar.find('.inventory').html(@_inventoryHTML(@data.items))
    sidebar.find("input[name=current_action]").val([App.game.current_action])
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

  _inventoryHTML: (items) ->
    $.map items, (item, i) ->
      "<li>#{item['name']} <a class='item-action' data-item-id='#{item['id']}'>Use</a></li>"

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
    @perform("move", {id: id, lat: latlng['latitude'], lon: latlng['longitude']})

  search: (id, latlng) ->
    @perform("search", {id: id, lat: latlng['latitude'], lon: latlng['longitude']})

  use_item: (character_id, item_id) ->
    @perform("use_item", {id: character_id, item_id: item_id})

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
