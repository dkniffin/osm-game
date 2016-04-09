App.game = {}

class window.Car

  DESELECTED_OPACITY = 0.7
  SELECTED_OPACITY = 1.0
  @_car: {}

  @sidebarSection = $('.sidebar .sidebar__car')

  @get: (id) ->
    @_cars[id]

  @upsert: (id, data) ->
    data = JSON.parse(data)
    if @_car[id] == undefined
      console.debug('making new car')
      @_car[id] = new Car(data)
    else
      console.debug("updating car")
      @_car[id].update(data)
    @_car[id]

  constructor: (@data) ->
    if App.map_mode == '3d'
      @model = App.osmb.addOBJ(App.models.car,
      { latitude: @data['lat'], longitude: @data['lon'] },
      { id: "var#{@data['id']}", color: 'red' })
    else
      @marker = L.marker([@data['lat'], @data['lon']],
      {icon: @_carIcon(@data['health']), opacity: DESELECTED_OPACITY})
      @marker.on('click', @select.bind(this))
      @marker.addTo(App.map)


  update: (data) ->
    @data = data

    if App.map_mode == '3d'
      @model.position = {latitude: data['lat'], longitude: data['lon']}
    else
      @marker.setIcon(@_carIcon(data.health))
      @marker.setLatLng([data['lat'], data['lon']])

    $('.header .health .value').html(data.health)
    if App.game.selected == this
      @_updateSidebar()

  select: (e) ->
    App.game.selected = this
    if App.map_mode == '2d'
      @marker.setOpacity(SELECTED_OPACITY)
    App.game.current_action = 'move'
    @_updateSidebar()

  unselect: (e) ->
    App.game.selected = null
    if App.map_mode == '3d'
      App.osmb.highlight(@data['id'])
    else
      @marker.setOpacity(DESELECTED_OPACITY)
    App.game.current_action = null
    @_hideSidebar()

  _updateSidebar: ->
    sidebar = $('.sidebar .sidebar__car')
    sidebar.find('.name').html(@data.name)
    sidebar.find('.health').html(@data.health)
    sidebar.show()

  _hideSidebar: ->
    sidebar = $('.sidebar .car')
    sidebar.hide()

  _carIcon: (health) ->
    L.divIcon({
      className: 'car-icon'
      iconSize:     [48, 48]
      iconAnchor:   [12, 12]
      html: "#{@_healthBarHTML(health)}"
  })

App.cars = App.cable.subscriptions.create "CarsChannel",
  connected: ->

    # Called when the subscription is ready for use on the server
  received: (data) ->
    Car.upsert(id, car) for id, car of data

  move: (id, latlng) ->
    @perform("move", {id: id, lat: latlng['lat'], lon: latlng['lng']})
