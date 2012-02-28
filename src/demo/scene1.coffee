iscene = (global) ->
  pinkie = global.fileloader.loadimg "img/pinkiepie.gif"
  sometext = [
    (frame, choice) ->
      sometext[5] = "You chose yes!" if choice is 0
      sometext[5] = "You chose no!" if choice is 1
      sometext[5] = "You chose hmm?" if choice is 2
      sometext[5] = "You made Pinkie cry :<" if choice is 3
      sometext[5] = "You're silly ^^" if choice is 4
    "Hi, I'm Pinkie Pie!"
    "I threw this party just for you!"
    "Were you surprised?"
    ":Yes:Nope:What?:Buck you:what now"
  ]
  spritelist = [
    new sprite 
      sheet  : pinkie
      area   : new rect 100, 100, 96, 96
      vector : 2
      len    : [1, 6, 6, 6]
      speed  : [0, 3, 6, 9]
    new sprite 
      sheet    : pinkie
      area     : new rect 500, 100, 96, 96
      collide  : true
      interact : true
      vector   : 4
      len      : [1, 6, 6, 6]
      speed    : [0, 3, 6, 9]
      callback : ->
        global.gfx.lookhere spritelist[0], spritelist[1]
        global.scenemgr.text.initialize sometext
    new sprite
      sheet    : pinkie
      area     : new rect 100, 500, 96, 96
      collide  : true
      interact : true
      vector   : -1
      len      : [1, 6, 6, 6]
      speed    : [0, 3, 6, 9]
      callback : ->
        global.fademgr.initialize "#CC0000", (frame) ->
          global.cutscenemgr.initialize global.fileloader, icutscene global if frame is 30
          if frame is 60 then -1
          else if frame <= 30 then frame / 30
          else if frame > 30 then (60 - frame) / 30
    new sprite
      area:new rect 0, 0, 50, 600
      collide:true
    new sprite
      area:new rect 0, 0, 800, 50
      collide:true
    new sprite
      area:new rect 0, 550, 800, 50
      collide:true
    new sprite
      area:new rect 750, 0, 50, 600
      collide:true
  ]
  global.scenemgr.initialize new scene(1000, 700, spritelist)
