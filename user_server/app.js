var io = require('socket.io')(3000);
var redis = require('redis');
var scripts = require('./scripts.json');

var REDIS_URL = "localhost"
var REDIS_PORT = 6379;
var redisClient = redis.createClient( REDIS_PORT, REDIS_URL );



io.on('connection', function (socket) {
    socket.broadcast.emit('join', socket['id']);
    console.log(socket['id'] + ' has connected!');
    
    socket.on('location', function (lat, lon) {
        console.log("Location: " + lat + ', ' + lon);
        socket.emit('update', lat, lon);
        var key = lat.toString() + ',' + lon.toString();
        redisClient.eval([scripts['exIncrElseSet'], 1, key], function (err, result){
            if(err){
                console.log(err);
            }
        });
    });

    socket.on('left', function (lat, lon) {
        console.log("Left: " + lat + ', ' + lon);
        var key = lat.toString() + ',' + lon.toString();
        redisClient.eval([scripts['rmIfOneElseDecr'], 1, key], function (err, result){
            if(err){
                console.log(err);
            }
            if (result == 1){
                socket.emit('disappear', lat, lon);
            }
        });
    });
    
    socket.on('reset', function(){
        console.log('Reset!');
        redisClient.flushall(function(err){
            if(err){
                console.log(err);
            }
        });
    });

    socket.on('disconnect', function (socket) {
        console.log(socket['id'] + ' has disconnected!');
    });
});