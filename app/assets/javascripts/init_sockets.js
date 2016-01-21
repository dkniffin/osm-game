// Set up the web sockets connection
var dispatcher = new WebSocketRails('localhost:3000/websocket');

function log_error(error) { console.error(error) }
