###
  Здесь реализована модель проекта. В частности игрок.
###

class World
  Enemies = {}
  constructor : (obj) ->
    switch typeof obj
      when 'undefined'
        @countP = 0
        @name = "World#{Math.ceil(Math.random() * 1000)}"
        @Players = []
        @bx1 = 0
        @bx2 = 1000
        @by1 = 0
        @by2 = 1000
      else
        @Players = obj.Players
        @countP = obj.countP
        @name = obj.name
        @bx1 = obj.bx1
        @bx2 = obj.bx2
        @by1 = obj.by1
        @by2 = obj.by2
  AddPlayer: (pl) ->
    @Players[@countP] = pl
    @countP++
  AddEnemy: (en)->
    #Enemies.push(en)
  constructor
  ChangePlayer: (pl)->
    if @Players[pl.number]? then @Players[pl.number] = pl


class Player
  constructor: (obj) ->
    @arraymove=["LOOK","WARRIOR","VOLUME","RUN","DEVIL","NOTE","ANDROID","COFFEE","SCRIPT","APPLE","BANG","GOOGLE","JOKE","ATOM","BASE",
                "BEGIN","MEMENTO","BREEZE","CARRY","CHECK","DANCE","UNIT","OTHER","HARD","CAPTURE","CONTRA","SWAP","POWER","TED","PICTURE","TIME",]
    @arrayenemy=["HUNTER","MOBILE","VOID","GREAT","EDITION","CANON","AGES","BLOOD","THIS","FLASH","BROKE","REPORT","CLICK","MOUSES","INSERT","TABLE","PUSH"]
    switch typeof obj
      when 'string'
        @name = obj
        @number=obj
        @x = obj.x
        @y = obj.y
        @ml = @array[@i]
        @mr = @array[@j]
        @md = @array[@l]
        @mu = @array[@m]
        @unit = @arrayenemy[@g]
      when 'object'
        @Bullets = obj.Bullets
        @countB = obj.countB
        @name = obj.name
        @number = obj.number
        @x = obj.x
        @y = obj.y
        @ml = obj.ml
        @mr = obj.mr
        @mu = obj.mu
        @md = obj.md
        @unit=obj.unit
      when 'undefined'
        @Bullets = []
        @countB = 0
        @g = Math.ceil(Math.random() *16)
        @unit=@arrayenemy[@g]

        @number = 0
        @name = "Player_"
        @x = Math.ceil(Math.random() * 500)
        @y = Math.ceil(Math.random() * 500)

        @i= Math.ceil(Math.random() * 9)
        @j= Math.ceil(10 + Math.random() * 5 )
        @l= Math.ceil(16 + Math.random() * 5)
        @m= Math.ceil(22+ Math.random() * 7)

        @ml = @arraymove[@i]
        @mr = @arraymove[@j]
        @mu = @arraymove[@m]
        @md = @arraymove[@l]
      else throw "Wrong player constructor."

  AddBullet: (B)->
    @Bullets[@countB] = B
    @countB++

  ChangeBullet: (B)->
    if @Bullets[B.number]? then @Bullets[B.number] = B

  html: (v) ->
    if v is 0
      """
      <div class='main'>
      <div id='#{@name}' class='player'>
      <div class='topblock'>#{@mu}</div>
      <div class='leftblock'>#{@ml}</div>
      <div class='centerblock'>#{@unit}</div>
      <div class='rightblock'>#{@mr}</div>
      <div class='bottomblock'>#{@md}</div>
      </div>
      </div>
      """

    else

      """
      <div class='main'>
      <div id='#{@name}' class='player'>
      <div class='topblock'>#{@mu}</div>
      <div class='leftblock'>#{@ml}</div>
      <div class='centerblock'>#{@unit}</div>
      <div class='rightblock'>#{@mr}</div>
      <div class='bottomblock'>#{@md}</div>
      </div>
      </div>
      """

  MoveTo: (v) ->
    switch v
      when 1
        @x-=60
        console.log "toLeft "+ @x+" "+@y
      when 3
        @x+=60
        console.log "toRight "+ @x+" "+@y
      when 2
        @y-=20
        console.log "toUp "+ @x+" "+ @y
      when 4
        @y+=20
        console.log "toDown "+ @x+" "+ @y
      else console.log "Fig"

###
@ChangeWord: ()->
      w = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
      while(w == Player.ml or w == Player.mr or w == Player.mu or w == Player.md)
        w = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        console.log "testing continue"
      console.log "lalala"
      w
###

class Word
  constructor:(@words=[]) ->
  addWord:(Name, word) ->
    @words[Name] =
      str  : word
      i    : 0
      func : @words[Name]?.func

  newChar:(char) ->
    for i, W of @words
      if char == W.str.charAt(W.i)
        W.i++
        if (W.i == W.str.length)
          W.i=0
          W.func()
      else
        if char != W.str.charAt(W.i)
          W.i=0
  addEventListener:(Name, callbackFunc) ->
    @words[Name].func = callbackFunc

class Bullet
  constructor: (obj) ->
    if obj.MoveTo
      @cr = obj.number
      @number = obj.countB
      @name = "B_#{@cr}_#{@number}"

      @x = obj.x + $('#'+obj.name).outerWidth()/2
      @y = obj.y + $('#'+obj.name).outerHeight()/2
    else
      @cr = obj.cr
      @name = obj.name
      @number = obj.number
      @x = obj.x
      @y = obj.y

  Replace:(dx, dy, r)->
    console.log "beforBx=" + @x
    console.log "beforBy=" + @y
    switch r
      when 1
        @x=@x+dx
        @y=@y+dy
      when 2
        @x=@x+dx
        @y=@y+dy
      when 3
        @x=@x+dx
        @y=@y+dy
      when 4
        @x=@x+dx
        @y=@y+dy
    console.log "afterBx=" + @x
    console.log "afterBy=" + @y
  html:() ->
    "<div id='#{@name}' class='bullet' style='background: rgb(#{255},#{208},#{255})'>B</div>"

module?.exports =
  Player : Player
#  Enemy  : Enemy
  World  : World
  Word   : Word
  Bullet : Bullet
window?.Player = Player
#window?.Enemy = Enemy
window?.World = World
window?.Word = Word
window?.Bullet = Bullet


