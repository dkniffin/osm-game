$ ->
  if App.map_mode == '3d'
    # Set up the map
    App.map = new GLMap 'map-3d',
      position: { latitude:35.992591, longitude:-78.903991 },
      zoom: 18,
      minZoom: 18,
      maxZoom: 22,
      tilt: 30,
      state: true # stores map position/rotation in url


    App.osmb = new OSMBuildings
      baseURL: '', # TODO: Fix this
      minZoom: 18,
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

    # App.osmb.addOBJ(App.models.car,
    #   { latitude: 35.991701, longitude: -78.903691 },
    #   { id: "car", color: 'red' })

    # App.icons = {}

    #***************************************************************************

    App.map.on 'pointermove', (e) ->
      id = App.osmb.getTarget e.x, e.y, (id) ->
        if id
          document.body.style.cursor = 'pointer'
          App.osmb.highlight(id)
        else
          document.body.style.cursor = 'default'
          App.osmb.highlight(null)

    App.map.on 'pointerdown', (e) ->
      id = App.osmb.getTarget e.x, e.y, (obj_id) ->
        if obj_id
          if typeof obj_id == "string"
            parts = obj_id.split "_"
            if parts[1]
              type = parts[0]
              id = parts[1]
              if type == 'character'
                # App.osmb.highlight(id)
                window.Character.get(id).select()
        else
    App.map.on 'contextmenu', (e) ->
      raw_coords = App.osmb.unproject(e.x, e.y)
      fixed_coords = { lat: raw_coords['latitude'], lon: raw_coords['longitude'] }
      switch App.game.current_action
        when 'move'
          App.characters.move(App.game.selected.data.id, fixed_coords)
        when 'search'
          App.characters.search(App.game.selected.data.id, fixed_coords)
    #
    #
    # App.map.on 'click', (e) ->
    #   App.game.selected.unselect()

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
