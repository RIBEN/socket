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
      console.log "testing continue"
    console.log "lalala"
    w
  funt=() -> console.log "пуля летит"

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
    if e.keyCode == 32
      B = new Bullet (me)
      setPlayerDiv(B)
      D = setInterval(B.Replace(),1000)

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
        setPlayerDiv(me)
        socket.emit('change user', me)
  )



)





