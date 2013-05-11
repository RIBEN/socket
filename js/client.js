//@ sourceMappingURL=client.map
// Generated by CoffeeScript 1.6.1

/*
  Здесь реализован весь клиентский JavaScript. Подразумевается, что модель
  подключается заранее.
*/


(function() {

  (function($) {
    return $(document).ready(function() {
      var Wc, en, me, setPlayerDiv, socket;
      socket = io.connect(document.URL.match(/^http:\/\/[^/]*/));
      /*
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
      */

      setPlayerDiv = function(pl) {
        var p;
        p = $('#' + pl.name);
        if (p.length === 0) {
          p = $(document.body).append(pl.html(0));
          p = $('#' + pl.name);
          p.css('left', pl.x + 'px');
          return p.css('top', pl.y + 'px');
        } else {
          p = p.html(pl.html(1));
          p.css('left', pl.x + 'px');
          return p.css('top', pl.y + 'px');
        }
      };
      Wc = new World();
      console.log("Wc.name=" + Wc.name);
      me = new Player();
      en = new Enemy();
      socket.emit('add user', me);
      socket.on('change name', function(name) {
        return me.name = name;
      });
      socket.on('Shut Up And Take My World', function(Ws) {
        var pl, _i, _len, _ref;
        Wc = new World(Ws);
        _ref = Wc.Players;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          pl = _ref[_i];
          setPlayerDiv(new Player(pl));
        }
        return console.log("Wc.name=" + Wc.name);
      });
      socket.on('user have been added', function(pl) {
        setPlayerDiv(new Player(pl));
        Wc.AddPlayer(pl);
        return console.log("Joined " + Wc.Players[pl.number].name);
      });
      socket.on('user have been changed', function(pl) {
        setPlayerDiv(new Player(pl));
        return Wc.ChangePlayer(pl);
      });
      socket.on('enemy have been added', function(data) {
        return setPlayerDiv(new Enemy(data));
      });
      socket.on('enemy have been changed', function(data) {
        return setPlayerDiv(new Enemy(data));
      });
      return $("body").keydown(function(e) {
        var b, l, r, _ref;
        switch (e.keyCode) {
          case 37:
            me.x -= 10;
            break;
          case 38:
            me.y -= 10;
            break;
          case 39:
            me.x += 10;
            break;
          case 40:
            me.y += 10;
            break;
          case 32:
            b = new Bullet(me);
            console.log("Bullet create from " + me.name);
        }
        /*
        if String.fromCharCode(e.keyCode) == "B"
            b = new Bullet(me)
            setPlayerDiv(b)
            #me.ml="#{ String.fromCharCode(Math.ceil(65 + Math.random() * 25  ) ) }"
            #socket.emit('change enemy', b)
        */

        if (String.fromCharCode(e.keyCode) === me.ml) {
          me.x -= 10;
          console.log(me.ml);
          l = "" + (String.fromCharCode(Math.ceil(65 + Math.random() * 25)));
          while (l === me.ml || l === me.mr) {
            l = "" + (String.fromCharCode(Math.ceil(65 + Math.random() * 25)));
          }
          me.ml = l;
          setPlayerDiv(me);
          socket.emit('change user', me);
        }
        if (String.fromCharCode(e.keyCode) === me.mr) {
          me.x += 10;
          console.log("mr=" + me.mr);
          r = "" + (String.fromCharCode(Math.ceil(65 + Math.random() * 25)));
          while (r === me.ml || r === me.mr) {
            r = "" + (String.fromCharCode(Math.ceil(65 + Math.random() * 25)));
          }
          me.mr = r;
          setPlayerDiv(me);
          socket.emit('change user', me);
        }
        if ((37 <= (_ref = e.keyCode) && _ref <= 40)) {
          setPlayerDiv(me);
          return socket.emit('change user', me);
        }
      });
    });
  })(jQuery);

}).call(this);
