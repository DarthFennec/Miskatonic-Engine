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
