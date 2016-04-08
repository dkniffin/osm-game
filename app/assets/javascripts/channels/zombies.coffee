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
    # @marker = L.marker([@data['lat'], @data['lon']],
    #   {icon: @_zombieIcon(@data['health']), opacity: DESELECTED_OPACITY})
    @model = App.osmb.addOBJ(App.models.zombie,
      { latitude: @data['lat'], longitude: @data['lon'] },
      { id: "zombie_#{@data['id']}", color: 'green' })
    # @marker.on('click', @select.bind(this))
    # @marker.addTo(App.map)

  update: (data) ->
    # @marker.setIcon(@_zombieIcon(data.health))
    # @marker.setLatLng([data['lat'], data['lon']])
    @model.position = {latitude: data['lat'], longitude: data['lon']}
    @data = data
    # $('.header .health .value').html(data.health)

  delete: () ->
    console.log('zombie killed')
    # App.map.removeLayer(@marker)

  select: (e) ->
    App.game.selected = this
    # @marker.setOpacity(SELECTED_OPACITY)

  unselect: (e) ->
    App.game.selected = null
    # @marker.setOpacity(DESELECTED_OPACITY)

  _zombieIcon: (health) ->
    L.divIcon({
      className: 'zombie-icon'
      iconSize:     [48, 48]
      iconAnchor:   [12, 12]
      html: "#{@_healthBarHTML(health)}"
    })

  _healthBarHTML: (health) ->
    "<progress value=#{health} max=100 />"

App.zombies = App.cable.subscriptions.create "ZombiesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    Zombie.upsert(id, zombie) for id, zombie of data
