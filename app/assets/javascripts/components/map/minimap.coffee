$ ->
  L.mapbox.accessToken = 'pk.eyJ1Ijoib2RkaXR5b3ZlcnNlZXIxMyIsImEiOiIwTEp5a1JnIn0.kzeYyqB2YOj2XXXECKKnJg'

  App.minimap = L.map('minimap',
    zoomControl: false
    attributionControl: false
    center: [
      52.52000
      13.41000
    ]
    zoom: 13)
  console.log(App.minimap)

  L.mapbox.styleLayer('mapbox://styles/oddityoverseer13/ciju0qw2900073slwb1yxdi25',
    minZoom: 5,
    maxZoom: 20
  ).addTo(App.minimap)


  bound_box = L.polygon([]).addTo(App.minimap)
  update_minimap_box = ->
    camera_bounds = App.map.getCameraBounds().map (coords) ->
      [coords.latitude, coords.longitude]
    bound_box.setLatLngs camera_bounds

  update_minimap_position = ->
    minimap_bounds = bound_box.getBounds()
    App.minimap.fitBounds minimap_bounds, padding: [50, 50]


  update_minimap_box()
  update_minimap_position()

  App.map.on 'change', update_minimap_box
  App.map.on 'pointerup', update_minimap_position
