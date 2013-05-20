//@ sourceMappingURL=model.map
// Generated by CoffeeScript 1.6.1

/*
  Здесь реализована модель проекта. В частности игрок.
*/


(function() {
  var Bullet, Player, World;

  World = (function() {
    var Enemies;

    Enemies = {};

    function World(obj) {
      switch (typeof obj) {
        case 'undefined':
          this.countP = 0;
          this.name = "World" + (Math.ceil(Math.random() * 1000));
          this.Players = [];
          this.bx1 = 0;
          this.bx2 = 1000;
          this.by1 = 0;
          this.by2 = 1000;
          break;
        default:
          this.Players = obj.Players;
          this.countP = obj.countP;
          this.name = obj.name;
          this.bx1 = obj.bx1;
          this.bx2 = obj.bx2;
          this.by1 = obj.by1;
          this.by2 = obj.by2;
      }
    }

    World.prototype.AddPlayer = function(pl) {
      this.Players[this.countP] = pl;
      return this.countP++;
    };

    World.prototype.AddEnemy = function(en) {};

    constructor;

    World.prototype.ChangePlayer = function(pl) {
      if (this.Players[pl.number] != null) {
        return this.Players[pl.number] = pl;
      }
    };

    return World;

  })();

  Player = (function() {

    function Player(obj) {
      switch (typeof obj) {
        case 'string':
          this.name = obj;
          this.x = obj.x;
          this.y = obj.y;
          this.ml = "" + (String.fromCharCode(Math.ceil(65 + Math.random() * 25)));
          this.mr = "" + (String.fromCharCode(Math.ceil(65 + Math.random() * 25)));
          break;
        case 'object':
          this.Bullets = obj.Bullets;
          this.countB = obj.countB;
          this.name = obj.name;
          this.number = obj.number;
          this.x = obj.x;
          this.y = obj.y;
          this.ml = obj.ml;
          this.mr = obj.mr;
          this.mu = obj.mu;
          this.md = obj.md;
          break;
        case 'undefined':
          this.Bullets = [];
          this.countB = 0;
          this.number = 0;
          this.name = "Player_";
          this.x = Math.ceil(Math.random() * 500);
          this.y = Math.ceil(Math.random() * 500);
          this.ml = String.fromCharCode(Math.ceil(65 + Math.random() * 25));
          this.mr = String.fromCharCode(Math.ceil(65 + Math.random() * 25));
          this.mu = String.fromCharCode(Math.ceil(65 + Math.random() * 25));
          this.md = String.fromCharCode(Math.ceil(65 + Math.random() * 25));
          break;
        default:
          throw "Wrong player constructor.";
      }
    }

    Player.prototype.AddBullet = function(B) {
      this.Bullets[this.countB] = B;
      return this.countB++;
    };

    Player.prototype.ChangeBullet = function(B) {
      if (this.Bullets[B.number] != null) {
        return this.Bullets[B.number] = B;
      }
    };

    Player.prototype.html = function(v) {
      if (v === 0) {
        return "<div id='" + this.name + "' class='player'>\n  <div class='top'>" + this.mu + "</div>\n  <div class='middle_line'>\n    <div class='left' style='background:rgb(" + 50 + "," + 255 + "," + 20 + ");display: inline-block;width: 10px;'>" + this.mr + "</div>\n    <div class=\"main\" style='background:rgb(" + 255 + "," + 0 + "," + 0 + ");display: inline-block;width: 70px;'>" + this.name + "</div>\n    <div class='right' style='background:rgb(" + 50 + "," + 255 + "," + 20 + ");display: inline-block;width:10px;'>" + this.mr + "</div>\n  </div>\n  <div class='bottom'>" + this.md + "</div>\n</div>";
      } else {
        return "<div class='top'>" + this.mu + "</div>\n<div class='middle_line'>\n  <div class='left' style='background:rgb(" + 50 + "," + 255 + "," + 20 + ");display: inline-block;width: 10px;'>" + this.ml + "</div>\n  <div class=\"main\" style='background:rgb(" + 255 + "," + 0 + "," + 0 + ");display: inline-block;width: 70px;'>" + this.name + "</div>\n  <div class='right' style='background:rgb(" + 50 + "," + 255 + "," + 20 + ");display: inline-block;width:10px;'>" + this.mr + "</div>\n</div>\n<div class='bottom'>" + this.md + "</div>";
      }
    };

    Player.prototype.MoveTo = function(v) {
      switch (v) {
        case 1:
          this.x -= 60;
          return console.log("toLeft " + this.x + " " + this.y);
        case 3:
          this.x += 60;
          return console.log("toRight " + this.x + " " + this.y);
        case 2:
          this.y -= 20;
          return console.log("toUp " + this.x + " " + this.y);
        case 4:
          this.y += 20;
          return console.log("toDown " + this.x + " " + this.y);
        default:
          return console.log("Fig");
      }
    };

    return Player;

  })();

  /*
  @ChangeWord: ()->
        w = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
        while(w == Player.ml or w == Player.mr or w == Player.mu or w == Player.md)
          w = "#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
          console.log "testing continue"
        console.log "lalala"
        w
  */


  Bullet = (function() {

    function Bullet(obj) {
      if (obj.MoveTo) {
        this.cr = obj.number;
        this.number = obj.countB;
        this.name = "B_" + this.cr + "_" + this.number;
        this.x = obj.x;
        this.y = obj.y;
      } else {
        this.cr = obj.cr;
        this.name = obj.name;
        this.number = obj.number;
        this.x = obj.x;
        this.y = obj.y;
      }
    }

    Bullet.prototype.Replace = function(dx, dy, r) {
      console.log("mr=" + r);
      console.log("beforBx=" + this.x);
      console.log("beforBy=" + this.y);
      switch (r) {
        case 1:
          this.x = this.x + dx;
          this.y = this.y - dy;
          break;
        case 2:
          this.x = this.x - dx;
          this.y = this.y - dy;
          break;
        case 3:
          this.x = this.x - dx;
          this.y = this.y + dy;
          break;
        case 4:
          this.x = this.x + dx;
          this.y = this.y + dy;
      }
      console.log("afterBx=" + this.x);
      return console.log("afterBy=" + this.y);
    };

    Bullet.prototype.html = function() {
      return "<div id='" + this.name + "' class='bullet' style='background: rgb(" + 255 + "," + 208 + "," + 255 + ")'>B_" + this.cr + "_" + this.number + "</div>";
    };

    return Bullet;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = {
      Player: Player,
      World: World,
      Bullet: Bullet
    };
  }

  if (typeof window !== "undefined" && window !== null) {
    window.Player = Player;
  }

  if (typeof window !== "undefined" && window !== null) {
    window.World = World;
  }

  if (typeof window !== "undefined" && window !== null) {
    window.Bullet = Bullet;
  }

}).call(this);
