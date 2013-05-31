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

  TerminatorBound = (obj)->
    if obj.Replace and (obj.x>=Wc.bx2 or obj.y>=Wc.by2 or obj.x<Wc.bx1 or obj.y<Wc.by1)
      console.log "Пуля дошла до границы. Она должна исчезнуть"
      $('#'+obj.name).remove()
      true
    else
      false

  TerminatorPlayer = (obj1,obj2)->
      console.log "TerminatorPlayer was begin"

      obj1 = new Bullet(obj1)
      obj2 = new Player(obj2)

      console.log "obj1.name " + obj1.name
      console.log "obj2.name " + obj2.name

      if( Into(obj2, obj1.x, obj1.y)is true)
        alert (obj2.name + "died")
        obj2.x+=100
        obj2.y+=100

        Wc.ChangePlayer(obj2)
        setPlayerDiv(obj2)
        $('#'+obj1.name).remove()
        console.log "obj1 cr " + obj1.cr
        socket.emit("bullet is deleted", obj1, Wc.Players[obj1.cr])
        socket.emit("user is deleted", obj2)
        #$('#'+obj2.name).remove()

        true
      else
        false

  Into = (obj2, x,y) ->
    console.log "Into was begin"
    obj2 = new Player(obj2)

    x0 = $("##{obj2.name} .centerblock").offset().left
    console.log "x0 " + x0
    y0 =  $("##{obj2.name}").offset().top - $("##{obj2.name}").outerHeight()
    console.log "y0 " + y0

    w = $("##{obj2.name} .centerblock").outerWidth()
    console.log "w " + w
    h =  $("##{obj2.name} .centerblock").offset().top - y0 + $("##{obj2.name} .centerblock").outerHeight()
    console.log "h " + h

    if( x>=x0 and y>=y0 and x<=x0+w and y<=y0+h )
        true
    else false

  FindDistanceX = (p1, p2) ->
     console.log "FindDistanceX begin works"

     console.log "p1.name " + p1.name
     console.log "p2.name " + p2.name

     x1 = $("##{p1.name} .centerblock").offset().left + $("##{p1.name} .centerblock").outerWidth()/2
     console.log "x1 " + x1
     y1 = $("##{p1.name} .centerblock").offset().top + $("##{p1.name} .centerblock").outerHeight()/2
     console.log "y1 " + y1

     x2 = $("##{p2.name} .centerblock").offset().left + $("##{p2.name} .centerblock").outerWidth()/2
     console.log "x2 " + x2
     y2 = $("##{p2.name} .centerblock").offset().top + $("##{p2.name} .centerblock").outerHeight()/2
     console.log "y2 " + y2

     d = Math.sqrt( (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1) )
     console.log "d " + d
     dx = Math.ceil(10*(x2-x1)/d)
     dx

  FindDistanceY = (p1, p2)->
    console.log "FindDistanceY begin works"

    console.log "p1.name " + p1.name
    console.log "p2.name " + p2.name

    x1 = $("##{p1.name} .centerblock").offset().left + $("##{p1.name} .centerblock").outerWidth()/2
    console.log "x1 " + x1
    y1 = $("##{p1.name} .centerblock").offset().top +  $("##{p1.name} .centerblock").outerHeight()/2
    console.log "y1 " + y1

    x2 = $("##{p2.name} .centerblock").offset().left + $("##{p2.name} .centerblock").outerWidth()/2
    console.log "x2 " + x2
    y2 = $("##{p2.name} .centerblock").offset().top + $("##{p2.name} .centerblock").outerHeight()/2
    console.log "y2 " + y2

    d = Math.sqrt( (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1) )
    console.log "d " + d

    dy = Math.ceil(10*(y2-y1)/d)
    dy

  Location = (p1, p2)->
    console.log "Location begin works"
    console.log "p1 " + p1.x + " " + p1.y
    console.log "p2 " + p2.x + " " + p2.y

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
#BEGIN############################################################################
  Wc = new World()
  console.log "Wc.name=" + Wc.name
  me = new Player()
  console.log me
  wd = new Word()
  kpl = 0
  kpl1=0

  socket.emit('add user', me)

  socket.on('change yourself',(plraw)->
    me = new Player(plraw)
  )
#SOCKET############################################################################
  socket.on('Shut Up And Take My World', (Ws) ->
    Wc = new World(Ws)
    console.log "Wc.x=" + Wc.bx2
    console.log "Wc.y=" + Wc.by2
    setPlayerDiv( new Player(pl) ) for pl in Wc.Players
    console.log "Wc.name=" + Wc.name
  )

#USER##############################################################################
  socket.on('user have been added', (plraw) ->
    pl = new Player(plraw)
    setPlayerDiv(pl)
    Wc.AddPlayer(pl)
    console.log "Joined " + Wc.Players[pl.number].name
  )

  socket.on('user have been changed', (plraw) ->
    pl = new Player(plraw)
    setPlayerDiv(pl)
    Wc.ChangePlayer(pl)
  )

  socket.on('user have been deleted',(plraw)->
    pl = new Player(plraw)
    Wc.ChangePlayer(pl)
    setPlayerDiv(pl)
    #$('#' + pl.name).remove()
    console.log "delete user" + pl.name
  )

#BULLET###############################################################################
  socket.on('bullet have been added',(B,plraw) ->
    pl = new Player(plraw)
    Wc.ChangePlayer(pl)
    setBDiv( new Bullet(B))
    console.log 'bullet have been added'
  )

  socket.on('bullet have been changed', (B, plraw) ->
    pl = new Player(plraw)
    Wc.ChangePlayer(pl)
    setBDiv( new Bullet(B) )
    console.log "bullet have been changed"
  )

  socket.on("bullet have been deleted", (B, plraw)->
    pl = new Player(plraw)
    Wc.ChangePlayer(pl)
    $('#'+ B.name).remove()
    console.log "bullet have been deleted"
  )
#END#####################################################################################
  wordsl = me.arraymove[me.i]
  wordsr = me.arraymove[me.j]
  wordsu = me.arraymove[me.m]
  wordsb = me.arraymove[me.l]
  wordsm = me.arrayenemy[me.g]

  wd.addWord('left',wordsl)
  wd.addWord('right',wordsr)
  wd.addWord('top',wordsu)
  wd.addWord('bottom',wordsb)

  ###
  wd.addWord('change',wordsm)

  wd.addEventListener('change', () ->
    me.g=Math.ceil(Math.random() * 15)
    me.unit=me.arrayenemy[me.g]
    wordsm=me.arrayenemy[me.g]
    wd.addWord('change',wordsm)
    Wc.ChangePlayer(me)
    setPlayerDiv(me)
    socket.emit('change user', me)
  )
  ###

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

    if(kpl is 0)
      kpl = 1
      for pl in Wc.Players when pl.unit isnt me.unit
        wordsm = pl.unit

        wd.addWord("kill_#{pl.number}",wordsm)

        wd.addEventListener("kill_#{pl.number}",
          do (pl = pl) -> () ->
            alert "kill_#{pl.number}"
            pl = new Player(pl)
            pl.g= Math.ceil(Math.random() *15)
            pl.unit=pl.arrayenemy[pl.g]
            wordsm=pl.unit
            wd.addWord("kill_#{pl.number}",wordsm)
            setPlayerDiv(pl)
          )

    if e.keyCode == 32
      r = Location(me,Wc.Players[1])

      console.log Wc.Players[0].name
      console.log "Result Location is " + r

      dx = FindDistanceX(me, Wc.Players[1])
      console.log "dx " + dx

      dy = FindDistanceY(me, Wc.Players[1])
      console.log "dy " + dy

      B = new Bullet(me)
      console.log B.name, B.x, B.y
      console.log "bullet cr " + B.cr
      me.AddBullet(B)

      socket.emit('add bullet',B,me)
      setBDiv(B)
      D = setInterval(
       ()->
           B.Replace(dx, dy)
           me.ChangeBullet(B)
           setBDiv(B)
           socket.emit("change bullet",B,me)
           Into(Wc.Players[1], B.x, B.y)
           if TerminatorBound(B) is true
             clearInterval(D)
             socket.emit("delete bullet",B, me)
           if TerminatorPlayer(B, Wc.Players[1]) is true
             clearInterval(D)

      ,10)

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

    if e.keyCode == 37
      me.MoveTo(1)
      me.i=ChangeWord()
      me.ml=me.arraymove[me.i]
      wordsl=me.arraymove[me.i]
      wd.addWord('left',wordsl)
      Wc.ChangePlayer(me)
      setPlayerDiv(me)
      socket.emit('change user', me)
      me.ml = ChangeWord()
      console.log me.ml

    if e.keyCode == 38
      me.MoveTo(2)
      me.m=ChangeWord()
      me.mu=me.arraymove[me.m]
      wordsu=me.arraymove[me.m]
      wd.addWord('top',wordsu)
      Wc.ChangePlayer(me)
      setPlayerDiv(me)
      socket.emit('change user', me)
      me.ml = ChangeWord()
      console.log me.ml

    if e.keyCode == 39
      me.MoveTo(3)
      me.j=ChangeWord()
      me.mr=me.arraymove[me.j]
      wordsr=me.arraymove[me.j]
      wd.addWord('right',wordsr)
      Wc.ChangePlayer(me)
      setPlayerDiv(me)
      socket.emit('change user', me)
      me.ml = ChangeWord()
      console.log me.ml

    if e.keyCode == 40
      me.MoveTo(4)
      me.l=ChangeWord()
      me.md=me.arraymove[me.l]
      wordsb=me.arraymove[me.l]
      wd.addWord('bottom',wordsb)
      Wc.ChangePlayer(me)
      setPlayerDiv(me)
      me.ml = ChangeWord()
      console.log me.ml


    wd.newChar(String.fromCharCode(e.keyCode))
  )

)








