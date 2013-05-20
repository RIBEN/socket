###
  Здесь реализована модель проекта. В частности игрок.
###

class World
  Enemies = {}
  Bullets = {}
  constructor : (obj) ->
    switch typeof obj
      when 'undefined'
        @count = 0
        @name = "World#{Math.ceil(Math.random() *500)}"
        @Players = []
        @bx1 = 0
        @bx2 = 1000
        @by1 = 0
        @by2 = 1000
      else
         @Players = obj.Players
         @count = obj.count
         @name = obj.name
         @bx1 = obj.bx1
         @bx2 = obj.bx2
         @by1 = obj.by1
         @by2 = obj.by2
  AddPlayer: (pl) ->
    @Players[@count] = pl
    @count++
  AddEnemy: (en)->
    #Enemies.push(en)
  AddBullet: (bullet)->
    #Bullets.push(bullet)
  constructor
  ChangePlayer: (pl)->
    if @Players[pl.number]? then @Players[pl.number] = pl

class Word
  constructor: () ->

  addWord:(Name, word) ->
    @words[Name] =
      str  : word
      i    : 0
      func : null


  newChar: (char) ->
    for W in @words
     if char == str.charAt(W.i)
      W.i++
      if (W.i == W.str.length)
        W.i=0
        W.func()

  addEventListener: (Name, callbackFunc) ->
    @words[Name].func = callbackFunc


class Player
  constructor: (obj, x, y) ->
    @arraymove=["LOOK","WARRIOR","VOLUME","RUN","DEVIL","NOTE","ANDROID","COFFEE","SCRIPT","APPLE","BANG","GOOGLE","JOKE","ATOM","BASE",
                "BEGIN","MEMENTO","BREEZE","CARRY","CHECK","DANCE","UNIT","OTHER","HARD","CAPTURE","CONTRACT","SWAP","POWER","TED","PICTURE","TIME"]
    @arrayenemy=["HUNTER","MOBILE","VOID","GREAT"]
    switch typeof obj
      when 'string'
        @name = obj
        @x = x
        @y = y
        @ml = @array[@i]
        @mr = @array[@j]
        @md = @array[@l]
        @mu = @array[@m]
        @unit=@arrayenemy[@g]
      when 'object'
        @name = obj.name
        @x = obj.x
        @y = obj.y
        @ml = obj.ml
        @mr = obj.mr
        @mu = obj.mu
        @md = obj.md
        @unit=obj.unit
      when 'undefined'
        @number = 0
        @g=Math.ceil(Math.random() * 3)
        @name ="Player_"
        @unit=@arrayenemy[@g]
        @x = Math.ceil(Math.random() * 500)
        @y = Math.ceil(Math.random() * 500)
        @i= Math.ceil(Math.random() * 30)
        @j= Math.ceil(Math.random() * 30)
        @l= Math.ceil(Math.random() * 30)
        @m= Math.ceil(Math.random() * 30)
        @ml = @arraymove[@i]
        @mr = @arraymove[@j]
        @mu = @arraymove[@m]
        @md = @arraymove[@l]
      else throw "Wrong player constructor."

  html: (v) ->
    if v is 0
      """
      <div id='#{@name}' class='player'>
      <div class='top' style='background:rgb(#{50},#{255},#{20});width:70px;'>#{@mu}</div>
      <div class='middle_line'>
      <div class='left' style='background:rgb(#{50},#{255},#{20});display: inline-block;width: 70px;'>#{@ml}</div>
      <div class="main" style='background:rgb(#{255},#{0},#{0});display: inline-block;width: 70px;'>#{@unit}</div>
      <div class='right' style='background:rgb(#{50},#{255},#{20});display: inline-block;width: 70px;'>#{@mr}</div>
      </div>
      <div class='bottom' style='background:rgb(#{50},#{255},#{20});width: 70px;'>#{@md}</div>
      </div>
      """
    else
      """
      <div class='top' style='background:rgb(#{50},#{255},#{20});width: 70px;'>#{@mu}</div>
      <div class='middle_line'>
      <div class='left' style='background:rgb(#{50},#{255},#{20});display: inline-block;width: 70px;'>#{@ml}</div>
      <div class="main" style='background:rgb(#{255},#{0},#{0});display: inline-block;width: 70px;'>#{@unit}</div>
      <div class='right' style='background:rgb(#{50},#{255},#{20});display: inline-block;width:70px;'>#{@mr}</div>
      </div>
      <div class='bottom' style='background:rgb(#{50},#{255},#{20});width: 70px;'>#{@md}</div>
      """
class Enemy
  constructor: (obj, x, y) ->
    switch typeof obj
      when 'string'
        @name = obj
        @x = x
        @y = y
      when 'object'
        @name = obj.name
        @x = obj.x
        @y = obj.y
      when 'undefined'
        @name = "Enemy#{Math.ceil(Math.random()*100)}"
        @x = Player.x
        @y = Player.y
        @cd = "23"
      else throw "Wrong enemy constructor."


  html: () ->
    "
    <div id='#{@name}' class='player' style='background: rgb(#{0},#{208},#{255})'>#{@name}
       <div id='#{@name}' class='player' style='background: rgb(#{50},#{255},#{20})'>#{@cd}</div>
    </div>
    "

class Bullet
  constructor: (obj) ->
    @name = "B"
    @x = obj.x + 45
    @y = obj.y - 30
  Replace:()->
    b.y+=10
  html: () ->
    """
    <div id='#{@name}' class='bullet' style='background: rgb(#{255},#{208},#{255})'>#{@name}</div>
    """
# exports for client (window.) and server (require(...).)
module?.exports =
  Player : Player
  Enemy  : Enemy
  World  : World
  Bullet : Bullet
    Word :Word
window?.Player = Player
window?.Word = Word
window?.Enemy = Enemy
window?.World = World
window?.Bullet = Bullet


