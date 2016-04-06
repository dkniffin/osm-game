$ ->
  # Set up the map
  # L.mapbox.accessToken = 'pk.eyJ1Ijoib2RkaXR5b3ZlcnNlZXIxMyIsImEiOiIwTEp5a1JnIn0.kzeYyqB2YOj2XXXECKKnJg'
  # App.map = L.mapbox.map('map').setView([35.992591, -78.903991], 20)
  # L.mapbox.styleLayer('mapbox://styles/oddityoverseer13/ciju0qw2900073slwb1yxdi25').addTo(App.map)

  App.map = new GLMap 'map',
    position: { latitude:35.992591, longitude:-78.903991 },
    zoom: 16,
    minZoom: 12,
    maxZoom: 20,
    tilt: 30,
    state: true # stores map position/rotation in url


  App.osmb = new OSMBuildings
    baseURL: '', # TODO: Fix this
    minZoom: 15,
    maxZoom: 22,
    effects: ['shadows'],
    attribution: '© 3D <a href="https://osmbuildings.org/copyright/">OSM Buildings</a>'

  App.osmb.addTo(App.map)

  App.osmb.addMapTiles(
    'https://{s}.tiles.mapbox.com/v3/osmbuildings.kbpalbpk/{z}/{x}/{y}.png',
    {
      attribution: '© Data <a href="https://openstreetmap.org/copyright/">OpenStreetMap</a> · © Map <a href="http://mapbox.com">MapBox</a>'
    }
  )

  App.osmb.addGeoJSONTiles('https://{s}.data.osmbuildings.org/0.2/anonymous/tile/{z}/{x}/{y}.json')

  # App.icons = {}

  #***************************************************************************

  # App.map.on 'pointermove', (e) ->
  #   id = osmb.getTarget e.x, e.y, (id) ->
  #     if id
  #       document.body.style.cursor = 'pointer'
  #       osmb.highlight(id, '#f08000')
  #     else
  #       document.body.style.cursor = 'default'
  #       osmb.highlight(null)


  App.map.on 'pointerup', (e) ->
    debugger
    switch App.game.current_action
      when 'move'
        App.characters.move(App.game.selected.data.id, e.latlng)
      when 'search'
        App.characters.search(App.game.selected.data.id, e.latlng)


  App.map.on 'click', (e) ->
    debugger
    App.game.selected.unselect()

  #***************************************************************************

  controlButtons = document.querySelectorAll('.control button')

  for button in controlButtons
    button.addEventListener 'click', (e) ->
      button = this
      parentClassList = button.parentNode.classList
      direction = button.classList.contains('inc') ? 1 : -1
      increment
      property

      if parentClassList.contains('tilt')
        property = 'Tilt'
        increment = direction*10
      if parentClassList.contains('rotation')
        property = 'Rotation'
        increment = direction*10
      if parentClassList.contains('zoom')
        property = 'Zoom'
        increment = direction*1
      if property
        map['set'+ property](map['get'+ property]()+increment)
