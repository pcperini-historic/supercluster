var ioc = require("socket.io-client");
var client = ioc("ws://localhost:3000");

client.emit('location', 1, 2);
console.log("FUCK");
client.emit('left', 1, 2);
client.emit('reset');