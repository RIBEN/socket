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
  ps = 0
  count = 0
  pl = 0
  pt = 0
  ty=0
  wordsl = me.arraymove[me.i]
  wordsr = me.arraymove[me.j]
  wordsu = me.arraymove[me.m]
  wordsb = me.arraymove[me.l]
  wordsm = me.arrayenemy[me.g]

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

    wd.addWord('left',wordsl)
    wd.newChar(e.charCode)
    wd.addEventListener('left', () ->
      me.l=Math.ceil(Math.random()*20)
      wordsl=me.arraymove[me.l]
      wd.addWord('left',wordsl)
      alert('left entered')
     )
    me.x-=100
    setPlayerDiv(me)
    socket.emit('change user', me)

    if String.fromCharCode(e.keyCode) == wordsr.charAt(ps)
      ps=ps+1
      if ps == wordsr.length
        ps=0
        me.x+=100
        me.j=Math.ceil(Math.random()*30)
        me.mr=me.arraymove[me.j]
        wordsr=me.arraymove[me.j]
    else if String.fromCharCode(e.keyCode) != wordsr.charAt(count)
      ps=0
    setPlayerDiv(me)
    socket.emit('change user', me)

    if String.fromCharCode(e.keyCode) == wordsu.charAt(pl)
      pl=pl+1
      if pl == wordsu.length
        pl=0
        me.y-=100
        me.m=Math.ceil(Math.random()*20)
        me.mu=me.arraymove[me.m]
        wordsu=me.arraymove[me.m]
    else if String.fromCharCode(e.keyCode) != wordsu.charAt(count)
      pl=0
    setPlayerDiv(me)
    socket.emit('change user', me)

    if String.fromCharCode(e.keyCode) == wordsb.charAt(pt)
      pt=pt+1
      if pt == wordsb.length
        pt=0
        me.y+=100
        me.l=Math.ceil(Math.random()*20)
        me.md=me.arraymove[me.l]
        wordsb=me.arraymove[me.l]
    else if String.fromCharCode(e.keyCode) != wordsb.charAt(count)
      pt=0
    setPlayerDiv(me)
    socket.emit('change user', me)



    if 37 <= e.keyCode <= 40
        setPlayerDiv(me)
        socket.emit('change user', me)
  )
)






