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
    switch typeof obj
      when 'string'
        @name = obj
        @x = obj.x
        @y = obj.y
        @ml = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        @mr = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
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
      when 'undefined'
        #@name = "Player#{Math.ceil(Math.random() * 1000)}"
        @Bullets = []
        @countB = 0

        @number = 0
        @name = "Player_"
        @x = Math.ceil(Math.random() * 500)
        @y = Math.ceil(Math.random() * 500)

        @ml = String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) )
        @mr = String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) )
        @mu = String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) )
        @md = String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) )
      else throw "Wrong player constructor."

  AddBullet: (B)->
    @Bullets[@countB] = B
    @countB++

  ChangeBullet: (B)->
    if @Bullets[B.number]? then @Bullets[B.number] = B

  html: (v) ->
    if v is 0
      """
      <div id='#{@name}' class='player'>
        <div class='top'>#{@mu}</div>
        <div class='middle_line'>
          <div class='left' style='background:rgb(#{50},#{255},#{20});display: inline-block;width: 10px;'>#{@mr}</div>
          <div class="main" style='background:rgb(#{255},#{0},#{0});display: inline-block;width: 70px;'>#{@name}</div>
          <div class='right' style='background:rgb(#{50},#{255},#{20});display: inline-block;width:10px;'>#{@mr}</div>
        </div>
        <div class='bottom'>#{@md}</div>
      </div>
      """
    else
      """
      <div class='top'>#{@mu}</div>
      <div class='middle_line'>
        <div class='left' style='background:rgb(#{50},#{255},#{20});display: inline-block;width: 10px;'>#{@ml}</div>
        <div class="main" style='background:rgb(#{255},#{0},#{0});display: inline-block;width: 70px;'>#{@name}</div>
        <div class='right' style='background:rgb(#{50},#{255},#{20});display: inline-block;width:10px;'>#{@mr}</div>
      </div>
      <div class='bottom'>#{@md}</div>
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

class Bullet
  constructor: (obj) ->
    if obj.MoveTo
      @cr = obj.number
      @number = obj.countB
      @name = "B_#{@cr}_#{@number}"

      @x = obj.x
      @y = obj.y
    else
      @cr = obj.cr
      @name = obj.name
      @number = obj.number
      @x = obj.x
      @y = obj.y

  Replace:(dx, dy, r)->
    console.log "mr=" + r
    console.log "beforBx=" + @x
    console.log "beforBy=" + @y
    switch r
      when 1
        @x=@x+dx
        @y=@y-dy
      when 2
        @x=@x-dx
        @y=@y-dy
      when 3
        @x=@x-dx
        @y=@y+dy
      when 4
        @x=@x+dx
        @y=@y+dy
    console.log "afterBx=" + @x
    console.log "afterBy=" + @y
  html:() ->
    "<div id='#{@name}' class='bullet' style='background: rgb(#{255},#{208},#{255})'>B_#{@cr}_#{@number}</div>"

module?.exports =
  Player : Player
#  Enemy  : Enemy
  World  : World
  Bullet : Bullet
window?.Player = Player
#window?.Enemy = Enemy
window?.World = World
window?.Bullet = Bullet


