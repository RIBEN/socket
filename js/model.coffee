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
        @name = "World#{Math.ceil(Math.random() * 1000)}"
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

class Player
  constructor: (obj, x, y) ->
    switch typeof obj
      when 'string'
        @name = obj
        @x = x
        @y = y
        @ml = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        @mr = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
      when 'object'
        @name = obj.name
        @x = obj.x
        @y = obj.y
        @ml = obj.ml
        @mr = obj.mr
      when 'undefined'
        #@name = "Player#{Math.ceil(Math.random() * 1000)}"
        @number = 0
        @name = "Player_"
        @x = Math.ceil(Math.random() * 500)
        @y = Math.ceil(Math.random() * 500)

        @ml = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        @mr = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
      else throw "Wrong player constructor."

  html: (v) ->
    if v is 0
      """
      <div id='#{@name}' class='player'>
        <div class='left' style='background:rgb(#{50},#{255},#{20});display: inline-block;width: 10px;'>#{@mr}</div>
        <div class="main" style='background:rgb(#{255},#{0},#{0});display: inline-block;width: 70px;'>#{@name}</div>
        <div class='right' style='background:rgb(#{50},#{255},#{20});display: inline-block;width:10px;'>#{@mr}</div>
      </div>
      """
    else
      """
      <div class='left' style='background:rgb(#{50},#{255},#{20});display: inline-block;width: 10px;'>#{@ml}</div>
      <div class="main" style='background:rgb(#{255},#{0},#{0});display: inline-block;width: 70px;'>#{@name}</div>
      <div class='right' style='background:rgb(#{50},#{255},#{20});display: inline-block;width:10px;'>#{@mr}</div>
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
        @name = "Enemy#{Math.ceil(Math.random() * 1000)}"
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
window?.Player = Player
window?.Enemy = Enemy
window?.World = World
window?.Bullet = Bullet


