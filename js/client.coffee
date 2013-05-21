do ($ = jQuery) -> $(document).ready(() ->
  socket = io.connect(document.URL.match(/^http:\/\/[^/]*/))

  setPlayerDiv = (pl) ->
    p = $('#' + pl.name)
    if p.length is 0
      p = $(document.body).append( pl.html(0) )
      p = $('#' + pl.name)
    else
      p = p.html(pl.html(1))
    #p = $(p).replaceWith(pl.html())
    p.css('left', pl.x + 'px')
    p.css('top',  pl.y + 'px')

  ChangeWord = ()->
    w =(Math.ceil(Math.random()* 30))
    while(w == me.i or w == me.j or w == me.l or w == me.m)
     w =(Math.ceil(Math.random()* 30))
    w


  Wc = new World()
  console.log "Wc.name=" + Wc.name
  me = new Player()
  en = new Enemy()
  wd = new Word()

  socket.emit('add user', me)

  socket.on('change name',(name)->
    me.name = name
  )

  socket.on('Shut Up And Take My World', (Ws) ->
    Wc = new World(Ws)
    setPlayerDiv( new Player(pl) ) for pl in Wc.Players
    console.log "Wc.name=" + Wc.name
  )

  socket.on('user have been added', (pl) ->
    setPlayerDiv( new Player(pl) )
    Wc.AddPlayer(pl)
    console.log "Joined " + Wc.Players[pl.number].name
  )

  socket.on('user have been changed', (pl) ->
    setPlayerDiv( new Player(pl) )
    Wc.ChangePlayer(pl)
  )

  socket.on('enemy have been added', (data) -> setPlayerDiv(new Enemy(data) ) )
  socket.on('enemy have been changed', (data) -> setPlayerDiv(new Enemy(data) ))

  wordsl = me.arraymove[me.i]
  wordsr = me.arraymove[me.j]
  wordsu = me.arraymove[me.m]
  wordsb = me.arraymove[me.l]
  i=0


  (
    wordsm = pl.arrayenemy[pl.g]
    wd.addWordEn('main',wordsm)
  ) for pl in Wc.Players when pl.unit isnt me.unit

  wd.addWord('left',wordsl)
  wd.addWord('right',wordsr)
  wd.addWord('top',wordsu)
  wd.addWord('bottom',wordsb)



  wd.addEventListenerE('main', () ->



    me.x-=7
    me.g=Math.ceil(Math.random()* 16)
    me.unit=me.arrayenemy[me.g]
    wordsm=me.arrayenemy[me.g]
    wd.addWord('main',wordsm)
    setPlayerDiv(me)
    socket.emit('change user', me))

  wd.addEventListener('left', () ->
    me.x-=50
    me.i=ChangeWord()
    me.ml=me.arraymove[me.i]
    wordsl=me.arraymove[me.i]
    wd.addWord('left',wordsl)
    setPlayerDiv(me)
    socket.emit('change user', me))

  wd.addEventListener('right', () ->
    me.x+=50
    me.j=ChangeWord()
    me.mr=me.arraymove[me.j]
    wordsr=me.arraymove[me.j]
    wd.addWord('right',wordsr)
    setPlayerDiv(me)
    socket.emit('change user', me))

  wd.addEventListener('top', () ->
    me.y-=50
    me.m=ChangeWord()
    me.mu=me.arraymove[me.m]
    wordsu=me.arraymove[me.m]
    wd.addWord('top',wordsu)
    setPlayerDiv(me)
    socket.emit('change user', me))

  wd.addEventListener('bottom', () ->
    me.y+=50
    me.l=ChangeWord()
    me.md=me.arraymove[me.l]
    wordsb=me.arraymove[me.l]
    wd.addWord('bottom',wordsb)
    setPlayerDiv(me)
    socket.emit('change user', me))




  $("body").keydown((e) ->
    switch e.keyCode
      when 37
        me.x -= 10
      when 38
        me.y -= 10
      when 39
        me.x += 10
      when 40
        me.y += 10

    wd.newChar(String.fromCharCode(e.keyCode))

    wd.newCharT(String.fromCharCode(e.keyCode))

    if 37 <= e.keyCode <= 40
      setPlayerDiv(me)
      socket.emit('change user', me)
    )
)





