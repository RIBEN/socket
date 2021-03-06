###
  BEGIN server routine
###
fs = require('fs')
app = require('http').createServer (req, res) ->
  page = if req.url is '/' then '/index.html' else req.url
  fs.readFile(
    __dirname + page,
  (err, data) ->
    if err
      res.writeHead 500
      res.end "Error loading #{page}"
    else
      res.writeHead 200
      res.end data
  )
io = require('socket.io').listen app
app.listen 12345
###
  END server routine
###
model = require('./js/model.js') # loading common model for game

Ws = new model.World()
io.sockets.on('connection', (socket) ->

#PLAYER
  socket.on('add user', (pl) ->
    pl.name = pl.name + Ws.countP
    pl.number = Ws.countP
    socket.emit('change name',pl.number)
    Ws.AddPlayer(pl)
    socket.emit('Shut Up And Take My World', Ws)
    #players[player.name] = new model.Player(player.name, player.x, player.y)
    socket.broadcast.emit('user have been added', pl )
  )

  socket.on('change user', (pl) ->
    Ws.ChangePlayer(pl)
    socket.broadcast.emit('user have been changed', pl)
  )

#BULLET
  socket.on('add bullet',(pl)->
    Ws.ChangePlayer(pl)
    socket.broadcast.emit('bullet have been added',pl)
  )

  socket.on('change bullet',(me)->
      Ws.ChangePlayer(pl)
      socket.broadcast.emit('bullet have been added',pl)
   )

  #Enemy
   ###
  socket.on('add enemy', (enemy) ->
    enemies[enemy.name] = new model.Enemy(enemy)
    socket.broadcast.emit('enemy have been added', enemies[enemy.name].raw())
    )

  socket.on('change enemy', (enemy) ->
    if enemies[enemy.name]? then enemies[enemy.name].change(enemy)
    socket.broadcast.emit('enemy have been changed', enemies[enemy.name].raw())
    )
   ###


)



