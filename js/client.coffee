###
  Здесь реализован весь клиентский JavaScript. Подразумевается, что модель
  подключается заранее.
###

do ($ = jQuery) -> $(document).ready(() ->
  socket = io.connect(document.URL.match(/^http:\/\/[^/]*/))
  ###
  Viewer=(obj)->
    if (obj instanceof Player)
      html = """
            <div id='#{@name}' class='player'>
              <div class='left' style='background:rgb(#{50},#{255},#{20});display: inline-block;width: 10px;'>#{@ml}</div>
              <div class="main" style='background:rgb(#{255},#{0},#{0});display: inline-block;width: 70px;'>#{@name}</div>
              <div class='right' style='background:rgb(#{50},#{255},#{20});display: inline-block;width:20px;'>#{@mr}</div>
            </div>
            """
      return html
    if (obj instanceof Enemy)
      return alert "This is class Enemy"
  ###
  ChangeWord = ()->
    w = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
    while(w == me.ml or w == me.mr or w == me.mu or w == me.md)
      w = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
    w


  FindDistanceX = (p1, p2)->
     x1 =p1.x + $('#'+p1.name).outerWidth()/2

     y1 = p1.y + $('#'+p1.name).outerHeight()/2
     x2 = p2.x + $('#' + p2.name).outerWidth()/2
     y2 = p2.y - $('#' + p2.name).outerHeight()/2

     d = Math.sqrt( (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1) )
     dx = Math.acos( (x2-x1)/d)*10
     console.log "dx=" + dx
     dx
  FindDistanceY = (p1, p2)->
    x1 =p1.x + $('#'+p1.name).outerWidth()/2

    y1 = p1.y + $('#'+p1.name).outerHeight()/2
    x2 = p2.x + $('#' + p2.name).outerWidth()/2
    y2 = p2.y - $('#' + p2.name).outerHeight()/2

    d = Math.sqrt( (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1) )
    dy = Math.asin( (y2-y1)/d)*10
    console.log "dy=" + dy
    dy

  Location = (p1, p2)->
    if p1.x<p2.x and p1.y>p2.y
       return 1
    if p1.x<p2.x and p1.y<p2.y
       return 4
    if p1.x>p2.x and p1.y<p2.y
       return 3
    if p1.x>p2.x and p1.y>p2.y
       2
  setPlayerDiv = (pl) ->
    p = $('#' + pl.name)
    if p.length is 0
      p = $(document.body).append( pl.html(0) )
      p = $('#' + pl.name)
    else
      p = p.html(pl.html(1))
    p.css('left', pl.x + 'px')
    p.css('top',  pl.y + 'px')

  setBDiv = (B) ->
    b = $('#' + B.name)
    if b.length is 0
      b = $(document.body).append( B.html() )
      b = $('#' + B.name)
    else
      b = b.html(B.html())
    b.css('left', B.x + 'px')
    b.css('top',  B.y + 'px')

  Wc = new World()
  console.log "Wc.name=" + Wc.name
  me = new Player()

  socket.emit('add user', me)

  socket.on('change name',(number)->
    me.number = number
    me.name = me.number
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

#BULLET
  socket.on('bullet have been added',(pl) ->
    Wc.ChangePlayer(pl)
    setBDiv( new Bullet(pl.Bullets[pl.countB-1]))
    console.log 'bullet have been added'
  )

  socket.on('bullet have been changed', (B) ->
    setBDiv( new Bullet(B) )
    Wc.ChangeBullet(B)
    console.log "bullet have been changed"
  )

  $("body").keydown((e) ->
    if e.keyCode == 32
      B = new Bullet(me)
      console.log B.name, B.number
      me.AddBullet(B)
      socket.emit('add bullet',me)
      setBDiv(B)
      r = Location(me, Wc.Players[1])
      console.log "r=" + r
      dx = FindDistanceX(me, Wc.Players[1])
      console.log "cdx"+dx
      dy = FindDistanceY(me, Wc.Players[1])
      console.log "cdy"+dy
      D = setInterval(
        ()->
            B.Replace(dx, dy, r)
            me.ChangeBullet(B)
            socket.emit('add bullet',me)
            setBDiv(B)
        ,1000,)

    if String.fromCharCode(e.keyCode) == me.ml
      me.MoveTo(1)
      me.ml = ChangeWord()
      console.log me.ml


    if String.fromCharCode(e.keyCode) == me.mr
      me.MoveTo(3)
      me.mr = ChangeWord()
      console.log "mr="+me.mr



    if String.fromCharCode(e.keyCode) == me.mu
      me.MoveTo(2)
      me.mu = ChangeWord()
      console.log me.mu


    if String.fromCharCode(e.keyCode) == me.md
      me.MoveTo(4)
      me.md = ChangeWord()
      console.log me.md

    if 65 <= e.keyCode <= 90
      Wc.ChangePlayer(me)
      setPlayerDiv(me)
      socket.emit('change user', me)
  )



)





