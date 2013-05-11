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
      when
        b = new Bullet(me)
        setInterval(
          ()->
            b.y-=10
            if(b.y<=0)
              clearInterval()
            setPlayerDiv(b)
            console.log "b.y="+b.y
          , 50)

###
    if String.fromCharCode(e.keyCode) == "B"
        b = new Bullet(me)
        setPlayerDiv(b)
        #me.ml="#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        #socket.emit('change enemy', b)
    ###
    if String.fromCharCode(e.keyCode) == me.ml
        me.x-=10
        console.log me.ml

        l = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        while(l == me.ml or l == me.mr)
          l = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        me.ml = l

        setPlayerDiv(me)
        socket.emit('change user', me)

    if String.fromCharCode(e.keyCode) == me.mr
        me.x+=10
        console.log "mr="+me.mr

        r = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        while(r == me.ml or r == me.mr)
          r = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        me.mr = r

        setPlayerDiv(me)
        socket.emit('change user', me)

    if 37 <= e.keyCode <= 40
        setPlayerDiv(me)
        socket.emit('change user', me)
  )



)





