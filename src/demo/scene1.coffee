iscene = new scenenode ["img/pinkiepie", "img/tent"],
  -> serv.outscenemgr.initialize [
    new sprite
      sheet  : @file[0]
      area   : new rect 100, 100, 96, 96
      vector : new angle "spr", 2
      len    : [1, 6, 6, 6]
      speed  : [0, 3, 6, 9]
    new sprite
      sheet    : @file[0]
      area     : new rect 500, 100, 96, 96
      collide  : true
      interact : true
      passive  : true
      vector   : new angle "spr", 4
      len      : [1, 6, 6, 6]
      speed    : [0, 3, 6, 9]
      callback : (subject, object) =>
        subject.vector.set "pts", subject.area.p, object.area.p
        @child[0].initialize()
    new sprite
      sheet    : @file[0]
      area     : new rect 100, 500, 96, 96
      collide  : true
      interact : true
      aiscript : serv.getai.follow 100, 150, 200
      vector   : (new angle "spr", -1)
      len      : [1, 6, 6, 6]
      speed    : [0, 3, 6, 9]
      callback : => @child[1].initialize()
    new tileset (new vect 100, 100), @file[1], [
      [21, 21, 21, 21, 21, 21, 21, 21, 21, 21]
      [21, 21, 21, 21, 21, 21, 21, 21, 21, 21]
      [21, 21, 21, 21, 21, 21, 21, 21, 21, 21]
      [21, 21, 21, 21, 1, -2, -3, -4, 5, 21]
      [21, 21, 21, 21, 6, -7, -8, -9, 10, 21]
      [21, 21, 21, 21, 11, -12, 13, -14, 15, 21]
      [21, 21, 21, 21, 16, 17, 18, 19, 20, 21]
      [21, 21, 21, 21, 21, 21, 21, 21, 21, 21]
    ]
  ]

iconvo = new scenenode [],
  -> serv.cutscenemgr.initialize [{
    txt: "Pinkie Pie#Hi, I'm Pinkie Pie!"
  }, {
    txt: "Pinkie Pie#I threw this party just for you!"
  }, {
    txt: ";Pinkie Pie#Were you surprised?#;Yes;Nope;What?;Buck you."
    next: (k) -> 3 + k
  }, {
    txt: "Pinkie Pie#You chose yes!"
    next: => @exitscene -1
  }, {
    txt: "Pinkie Pie#You chose no!"
    next: => @exitscene -1
  }, {
    txt: "Pinkie Pie#You chose hmm?"
    next: => @exitscene -1
  }, {
    txt: "#You made Pinkie cry :<"
    next: => @exitscene -1
  }]
