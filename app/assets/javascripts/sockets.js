var dispatcher = new WebSocketRails('localhost:3000/websocket');

var success = function(character) { console.log(character); }

dispatcher.trigger('character.get', { id: 1 }, success);
