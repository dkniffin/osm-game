$ ->
  if App.map_mode == '2d'
    # Set up the map
    App.leaflet_map = L.mapbox.map('map').setView([35.992591, -78.903991], 20)
    L.mapbox.styleLayer(App.mapbox_style_url).addTo(App.leaflet_map)

    App.icons = {}

    App.leaflet_map.on 'contextmenu', (e) ->
      switch App.game.current_action
        when 'move'
          App.characters.move(App.game.selected.data.id, e.latlng)
        when 'search'
          App.characters.search(App.game.selected.data.id, e.latlng)


    App.leaflet_map.on 'click', (e) ->
      App.game.selected.unselect()
