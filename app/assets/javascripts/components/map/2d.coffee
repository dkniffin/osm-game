$ ->
  if App.map_mode == '2d'
    # Set up the map
    L.mapbox.accessToken = 'pk.eyJ1Ijoib2RkaXR5b3ZlcnNlZXIxMyIsImEiOiIwTEp5a1JnIn0.kzeYyqB2YOj2XXXECKKnJg'
    App.map = L.mapbox.map('map').setView([35.992591, -78.903991], 20)
    L.mapbox.styleLayer('mapbox://styles/oddityoverseer13/ciju0qw2900073slwb1yxdi25').addTo(App.map)

    App.icons = {}

    App.map.on 'contextmenu', (e) ->
      debugger
      switch App.game.current_action
        when 'move'
          App.characters.move(App.game.selected.data.id, e.latlng)
        when 'search'
          App.characters.search(App.game.selected.data.id, e.latlng)


    App.map.on 'click', (e) ->
      App.game.selected.unselect()
