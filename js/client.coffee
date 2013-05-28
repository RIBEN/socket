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

  Pixel = (p0,p2,n)->
      P = new Point(p0,p2,n)
      setBDiv(P)

  ChangeWord = ()->
    w =(Math.ceil(Math.random()* 30))
    while(w == me.i or w == me.j or w == me.l or w == me.m)
      w =(Math.ceil(Math.random()* 30))
    w

  Terminator = (obj)->
    if obj.Replace and (obj.x>=Wc.bx2 or obj.y>=Wc.by2 or obj.x<Wc.bx1 or obj.y<Wc.by1)
      console.log "ща исчезнет пуля"
      $('#'+obj.name).remove()
      true
    else
      false

  Into = (obj, pl)->
    x1 = pl.x
    y1 = pl.y
    x2 = x1 + $("##{pl.name} .main").outerWidth()
    y2 = y1 + $("##{pl.name} .main").outerHeight()
    if obj.x>=x1 and obj.x<=x2 and obj.y>=y1 and obj.y<=y2 and obj.cr isnt pl.number
      console.log "hi"
      true
    else false

  FindDistanceX = (p1, p2)->
     console.log "FindDistanceX begin works"
     console.log "p1.name " + p1.name + " " + p1.x + " " + p1.y
     console.log "p2.name " + p2.name + " " + p2.x + " " + p2.y

     console.log "p1.Width " + $('#' + p1.name).outerWidth()/2
     console.log "p1.Hight " + $('#' + p1.name).outerHeight()/2

     console.log "p2.Width " + $('#' + p2.name).outerWidth()/2
     console.log "p2.Hight " + $('#' + p2.name).outerHeight()/2

     x1 = p1.x + $('#' + p1.name).outerWidth()/2
     console.log "x1 " + x1
     y1 = p1.y + $('#' + p1.name).outerHeight()/2
     console.log "y1 " + y1
     x2 = p2.x + $('#' + p2.name).outerWidth()/2
     console.log "x2 " + x2
     y2 = p2.y - $('#' + p2.name).outerHeight()/2
     console.log "y2 " + y2

     d = Math.sqrt( (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1) )
     console.log "d " + d
     dx = Math.ceil(10*(x2-x1)/d)
     dx

  FindDistanceY = (p1, p2)->
    console.log "FindDistanceY begin works"
    console.log "p1.name " + p1.name + " " + p1.x + " " + p1.y
    console.log "p2.name " + p2.name + " " + p2.x + " " + p2.y

    console.log "p1.Width " + $('#' + p1.name).outerWidth()/2
    console.log "p1.Hight " + $('#' + p1.name).outerHeight()/2

    console.log "p2.Width " + $('#' + p2.name).outerWidth()/2
    console.log "p2.Hight " + $('#' + p2.name).outerHeight()/2

    x1 = p1.x + $('#' + p1.name).outerWidth()/2
    console.log "x1 " + x1
    y1 = p1.y + $('#' + p1.name).outerHeight()/2
    console.log "y1 " + y1
    x2 = p2.x + $('#' + p2.name).outerWidth()/2
    console.log "x2 " + x2
    y2 = p2.y - $('#' + p2.name).outerHeight()/2
    console.log "y2 " + y2

    d = Math.sqrt( (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1) )
    console.log "d " + d

    dy = Math.ceil(10*(y2-y1)/d)
    dy

  Location = (p1, p2)->
    console.log "Location begin works"
    console.log "p1 " + p1.x + " " + p1.y
    Pixel(p1.x,p1.y,1)
    console.log "p2 " + p2.x + " " + p2.y
    Pixel(p2.x,p2.y,3)

    if p1.x < p2.x and p1.y > p2.y
       return 1
    if p1.x < p2.x and p1.y < p2.y
       return 4
    if p1.x > p2.x and p1.y < p2.y
       return 3
    if p1.x > p2.x and p1.y > p2.y
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

  setPDiv = (P) ->
    p = $('#' + P.name)
    p = $(document.body).append( P.html() )
    p = $('#' + P.name)
    p.css('left', P.x + 'px')
    p.css('top',  P.y + 'px')

  Wc = new World()
  console.log "Wc.name=" + Wc.name
  me = new Player()
  console.log me
  wd = new Word()

  socket.emit('add user', me)

  socket.on('change yourself',(pl)->
    me = new Player(pl)
  )

  socket.on('Shut Up And Take My World', (Ws) ->
    Wc = new World(Ws)
    console.log "Wc.x="+Wc.bx2
    console.log "Wc.y="+Wc.by2
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

  socket.on('delete user',(pl)->
    Wc.ChangePlyaer(pl)
    $('#' + pl.name).remove()
    console.log "delete user"+ pl.name
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

  wordsl = me.arraymove[me.i]
  wordsr = me.arraymove[me.j]
  wordsu = me.arraymove[me.m]
  wordsb = me.arraymove[me.l]

  wd.addWord('left',wordsl)
  wd.addWord('right',wordsr)
  wd.addWord('top',wordsu)
  wd.addWord('bottom',wordsb)

  for pl in Wc.Players when pl.unit isnt me.unit
   wordsm = me.arrayenemy[me.g]
  wd.addWord("kill_#{pl.number}",wordsm)
  wd.addEventListener("kill_#{pl.number}", () ->
     alert "kill_#{pl.number}"
  )

  wd.addEventListener('left', () ->
    me.MoveTo(1)
    me.i=ChangeWord()
    me.ml=me.arraymove[me.i]
    wordsl=me.arraymove[me.i]
    wd.addWord('left',wordsl)
    Wc.ChangePlayer(me)
    setPlayerDiv(me)
    socket.emit('change user', me)
  )

  wd.addEventListener('right', () ->
    me.MoveTo(3)
    me.j=ChangeWord()
    me.mr=me.arraymove[me.j]
    wordsr=me.arraymove[me.j]
    wd.addWord('right',wordsr)
    Wc.ChangePlayer(me)
    setPlayerDiv(me)
    socket.emit('change user', me)
  )

  wd.addEventListener('top', () ->
    me.MoveTo(2)
    me.m=ChangeWord()
    me.mu=me.arraymove[me.m]
    wordsu=me.arraymove[me.m]
    wd.addWord('top',wordsu)
    Wc.ChangePlayer(me)
    setPlayerDiv(me)
    socket.emit('change user', me)
  )

  wd.addEventListener('bottom', () ->
    me.MoveTo(4)
    me.l=ChangeWord()
    me.md=me.arraymove[me.l]
    wordsb=me.arraymove[me.l]
    wd.addWord('bottom',wordsb)
    Wc.ChangePlayer(me)
    setPlayerDiv(me)

    socket.emit('change user', me)
  )

  $("body").keydown((e) ->

    if e.keyCode == 32
      r = Location(me,Wc.Players[1])
      console.log "Result Location is " + r

      dx = FindDistanceX(me, Wc.Players[1])
      console.log "dz " + dx

      dy = FindDistanceY(me, Wc.Players[1])
      console.log "dy " + dy

      B = new Bullet(me)
      console.log B.name
      me.AddBullet(B)
      socket.emit('add bullet',me)
      setBDiv(B)
      D = setInterval(
         ()->
            B.Replace(dx, dy, r)
            me.ChangeBullet(B)
            setBDiv(B)
      ,100)


    if String.fromCharCode(e.keyCode) == me.ml
      me.ml = ChangeWord()
      console.log me.ml

    if String.fromCharCode(e.keyCode) == me.mr
      me.mr = ChangeWord()
      console.log "mr="+me.mr

    if String.fromCharCode(e.keyCode) == me.mu
      me.mu = ChangeWord()
      console.log me.mu


    if String.fromCharCode(e.keyCode) == me.md
      me.md = ChangeWord()
      console.log me.md

    if 65 <= e.keyCode <= 90
      setPlayerDiv(me)
      socket.emit('change user', me)

    wd.newChar(String.fromCharCode(e.keyCode))
  )

)








