iscene = (global) ->
  global.fileloader.loadandrun ["img/pinkiepie.gif", "img/tent.png"], miscene, global

miscene = (images, global) ->
  global.scenemgr.initialize [
    new sprite 
      sheet  : images[0]
      area   : new rect 100, 100, 96, 96
      vector : 2
      len    : [1, 6, 6, 6]
      speed  : [0, 3, 6, 9]
    new sprite 
      sheet    : images[0]
      area     : new rect 500, 100, 96, 96
      collide  : true
      interact : true
      vector   : 4
      len      : [1, 6, 6, 6]
      speed    : [0, 3, 6, 9]
      callback : (subject, object) ->
        subject.lookhere object, yes
        global.scenemgr.text.initialize [
          (text, frame, choice) ->
            text[5] = "You chose yes!" if choice is 0
            text[5] = "You chose no!" if choice is 1
            text[5] = "You chose hmm?" if choice is 2
            text[5] = "You made Pinkie cry :<" if choice is 3
            text[5] = "You're silly ^^" if choice is 4
          "Hi, I'm Pinkie Pie!"
          "I threw this party just for you!"
          "Were you surprised?"
          ":Yes:Nope:What?:Buck you:what now"
        ]
    new sprite
      sheet    : images[0]
      area     : new rect 100, 500, 96, 96
      collide  : true
      interact : true
      vector   : -1
      len      : [1, 6, 6, 6]
      speed    : [0, 3, 6, 9]
      callback : ->
        global.fademgr.initialize "#CC0000", (frame) ->
          icutscene global if frame is 30
          if frame is 60 then -1
          else if frame <= 30 then frame / 30
          else if frame > 30 then (60 - frame) / 30
    new tileset new vect(100, 100), images[1], new vect(10, 8), [
      20, 20, 20, 20, 20, 20, 20, 20, 20, 20
      20, 20, 20, 20, 20, 20, 20, 20, 20, 20
      20, 20, 20, 20, 20, 20, 20, 20, 20, 20
      20, 20, 20, 20, 00, 01, 02, 03, 04, 20
      20, 20, 20, 20, 05, 06, 07, 08, 09, 20
      20, 20, 20, 20, 10, 11, 12, 13, 14, 20
      20, 20, 20, 20, 15, 16, 17, 18, 19, 20
      20, 20, 20, 20, 20, 20, 20, 20, 20, 20
    ]
  ]
