App.gameData =
  characterMarkers: {}
  characters: ->

    update: (id, data) ->
      marker = @getOrCreateMarker(id)
      marker.setLatLng([data['lat'], data['lon']])

    getOrCreateMarker: (id) ->
      if App.gameData.characterMarkers[id] == undefined
        console.log('making new marker')
        App.gameData.characterMarkers[id] = L.marker([0,0], {icon: App.icons.characterIcon}).addTo(App.map)
      App.gameData.characterMarkers[id]
App.characters = App.cable.subscriptions.create "CharactersChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    App.gameData.characters().update(id, character) for id, character of data

  move: (id, lat, lon) ->
    @perform("move", id: id, lat: lat, lon: lon)



# // Query the server for all characters, then display them on the map as markers
# dispatcher.trigger('character.all', {}, function(characters){
#   $(characters).each(function(i,character){
#     coords = [character.lat, character.lon]
#     L.marker(coords, {icon: characterIcon}).addTo(map);
#   })
# }, log_error);
