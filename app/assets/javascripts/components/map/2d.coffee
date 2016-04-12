$ ->
  # Set up the map
  L.mapbox.accessToken = 'pk.eyJ1Ijoib2RkaXR5b3ZlcnNlZXIxMyIsImEiOiIwTEp5a1JnIn0.kzeYyqB2YOj2XXXECKKnJg'

  if App.map_mode == '2d'
    map_container_id = 'map'
  else
    map_container_id = 'minimap'
  App.leaflet_map = L.mapbox.map(map_container_id).setView([35.992591, -78.903991], 20)
  L.mapbox.styleLayer('mapbox://styles/oddityoverseer13/ciju0qw2900073slwb1yxdi25').addTo(App.leaflet_map)

  App.icons = {}

  App.leaflet_map.on 'contextmenu', (e) ->
    switch App.game.current_action
      when 'move'
        App.characters.move(App.game.selected.data.id, e.latlng)
      when 'search'
        App.characters.search(App.game.selected.data.id, e.latlng)


  App.leaflet_map.on 'click', (e) ->
    App.game.selected.unselect()
