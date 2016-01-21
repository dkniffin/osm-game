$(document).ready(function(){
  // Set up the map
  var map = L.mapbox.map('map', 'oddityoverseer13.map-y6b598y4').setView([35.992591, -78.903991], 20);

  // Query the server for all characters, then display them on the map as markers
  dispatcher.trigger('character.all', {}, function(characters){
    $(characters).each(function(i,character){
      coords = [character.lat, character.lon]
      L.marker(coords).addTo(map);
    })
  }, log_error);
})
