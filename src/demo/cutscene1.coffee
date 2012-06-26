icutscene = new scenenode ["img/room.test0", "img/thumb.art1", "img/artifact.quest"],
  -> serv.cutscenemgr.initialize [{
    len: 150
    elem: [
      new particle @file[2], (t) -> [(Math.cos Math.PI*t/30)*200 + 350, (Math.sin Math.PI*t/30)*200 + 250, 1, 1]
      new particle @file[1], (t) -> [350, 250, 1, (@fadeform t, 30)]
      new particle @file[0], (t) -> [0, 0, 1, 1]
    ]
    txt: "#This is some text during a cutscene."
  }, {
    len: 0
    elem: [
      new particle @file[2], (t) -> @zoomform 64, 64, 400, 300, (Math.cos Math.PI*t/30) + 1, 1
      new particle @file[0], (t) -> [0, 0, 1, 1]
    ]
    txt: ";#Make your choice:#;Choice One;Choice Two"
    next: (k) -> 2 + k
  }, {
    len: 50
    txt: "#You chose one!"
    next: => @exitscene -1
  }, {
    len: 50
    txt: "#You chose two!"
    next: => @exitscene -1
  }]
