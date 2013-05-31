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
    x1 =p1.x + $('#'+p1.name).outerWidth()/2
    y1 = p1.y + $('#'+p1.name).outerHeight()/2
    x2 = p2.x + $('#' + p2.name).outerWidth()/2
    y2 = p2.y - $('#' + p2.name).outerHeight()/2

    d = Math.sqrt( (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1) )
    dx = Math.ceil(10*(x2-x1)/d)
    console.log "dx=" + dx
    dx
  FindDistanceY = (p1, p2)->
    x1 =p1.x + $('#'+p1.name).outerWidth()/2
    y1 = p1.y + $('#'+p1.name).outerHeight()/2
    x2 = p2.x + $('#' + p2.name).outerWidth()/2
    y2 = p2.y - $('#' + p2.name).outerHeight()/2

    d = Math.sqrt( (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1) )
    dy = Math.ceil(10*(y2-y1)/d)
    console.log "dy=" + dy
    dy

  Location = (p1, p2)->
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
      p = $(document.body).append(pl.html(0))
      p = $('#' + pl.name)
    else
      p = p.html(pl.html(1))
    p.css('left', pl.x + 'px')
    p.css('top',  pl.y + 'px')

  setBDiv = (B) ->
    b = $('#' + B.name)
    if b.length is 0
      b = $(document.body).append( B.html())
      b = $('#' + B.name)
    else
      b = b.html(B.html())
    b.css('left', B.x + 'px')
    b.css('top',  B.y + 'px')

  Wc = new World()
  console.log "Wc.name=" + Wc.name
  me = new Player()
  wd = new Word()

  socket.emit('add user', me)

  socket.on('change name',(number)->
    me.number = number
    me.name = me.name + me.number
  )

  socket.on('Shut Up And Take My World', (Ws) ->
    Wc = new World(Ws)
    console.log "Wc.x="+Wc.bx2
    console.log "Wc.y="+Wc.by2
    setPlayerDiv( new Player(pl) ) for pl in Wc.Players
    console.log "Wc.name=" + Wc.name
  )

  socket.on('user have been added',(pl_raw) ->
    pl = new Player(pl_raw)
    setPlayerDiv(pl)
    Wc.AddPlayer(pl)

    wordsm = pl.unit

    wd.addWord("kill_#{pl.number}",wordsm)

    wd.addEventListener("kill_#{pl.number}",() ->
      alert "kill_#{pl.number}"
      pl.g= Math.ceil(Math.random() *15)
      pl.unit=pl.arrayenemy[pl.g]
      wordsm=pl.unit
      wd.addWord("kill_#{pl.number}",wordsm)
      setPlayerDiv(pl)
    )
    console.log "Joined " + Wc.Players[pl.number].name

  )

  socket.on('user have been changed', (pl_raw) ->
    pl = new Player(pl_raw)
    setPlayerDiv(pl)
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

    if e.keyCode == 16
      for pl in Wc.Players when pl.unit isnt me.unit
        wordsm = pl.unit

        wd.addWord("kill_#{pl.number}",wordsm)

        wd.addEventListener("kill_#{pl.number}",
          do (pl = pl) -> () ->
            alert "kill_#{pl.number}"
            pl.g= Math.ceil(Math.random() *15)
            pl.unit=pl.arrayenemy[pl.g]
            wordsm=pl.unit
            wd.addWord("kill_#{pl.number}",wordsm)
            setPlayerDiv(pl)
           )

    if e.keyCode == 32
      $(Player_1).remove()
      B = new Bullet(me)
      console.log B.name, B.number
      me.AddBullet(B)
      socket.emit('add bullet',me)
      setBDiv(B)

      r = Location(me, Wc.Players[1])
      dx = FindDistanceX(me, Wc.Players[1])
      dy = FindDistanceY(me, Wc.Players[1])

      D = setInterval(
                       ()->
                         B.Replace(dx, dy, r)
                         me.ChangeBullet(B)
                         setBDiv(B)
                         console.log "Into=" + Into(B, WcPlayer[1])
                         if Terminator(B,Wc.Players[1]) is true
                           clearInterval(D)
                           $(Player_1).remove()
                           B.x=2000
                           B.y=2000
                     ,1)
    ###
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
    ###
    wd.newChar(String.fromCharCode(e.keyCode))
  )
)
