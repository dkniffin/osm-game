class window.Zombie

  DESELECTED_OPACITY = 0.7
  SELECTED_OPACITY = 1.0
  @_zombies: {}

  @get: (id) ->
    @_zombies[id]

  @upsert: (id, data) ->
    data = JSON.parse(data)
    if @_zombies[id] == undefined
      console.debug('making new zombie')
      @_zombies[id] = new Zombie(data)
    else
      @_zombies[id].update(data)
      if @_zombies[id].data.health <= 0

        @_zombies[id].delete()
        delete @_zombies[id]
    @_zombies[id]

  constructor: (@data) ->
    if App.map_mode == '3d'
      @model = App.osmb.addOBJ(App.models.zombie,
        { latitude: @data['lat'], longitude: @data['lon'] },
        { id: "zombie_#{@data['id']}", color: 'green' })
    else
      @marker = L.marker([@data['lat'], @data['lon']],
        {icon: @_zombieIcon(@data['health']), opacity: DESELECTED_OPACITY})
      @marker.on('click', @select.bind(this))
      @marker.addTo(App.leaflet_map)

  update: (data) ->
    @data = data
    if App.map_mode == '3d'
      @model.position = {latitude: @data['lat'], longitude: @data['lon']}
    else
      @marker.setIcon(@_zombieIcon(@data.health))
      @marker.setLatLng([@data['lat'], @data['lon']])

    # $('.header .health .value').html(data.health)

  delete: () ->
    console.log('zombie killed')
    if App.map_mode == '2d'
      App.leaflet_map.removeLayer(@marker)

  select: (e) ->
    App.game.selected = this
    if App.map_mode == '2d'
      @marker.setOpacity(SELECTED_OPACITY)

  unselect: (e) ->
    App.game.selected = null
    if App.map_mode == '2d'
      @marker.setOpacity(DESELECTED_OPACITY)

  _zombieIcon: (health) ->
    L.divIcon({
      className: 'zombie-icon'
      iconSize:     [48, 48]
      iconAnchor:   [12, 12]
      html: "#{@_healthBarHTML(health)}"
    })

  _healthBarHTML: (health) ->
    "<div class=progress-bar-outside>" +
      "<div class=progress-bar-inside style='width: #{health}%;'></div>" +
    "</div>"
