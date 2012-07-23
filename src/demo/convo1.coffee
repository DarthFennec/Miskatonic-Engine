iconvo = new scenenode [],
  -> serv.cutscenemgr.initialize [{
    txt: "Pinkie Pie\nHi, I'm Pinkie Pie!"
  }, {
    txt: "Pinkie Pie\nI threw this party just for you!"
  }, {
    txt: "\tPinkie Pie\nWere you surprised?\tYes\tNope\tWhat?\tBuck you."
    next: (k) -> 3 + k
  }, {
    txt: "Pinkie Pie\nYou chose yes!"
    next: => @exitscene -1
  }, {
    txt: "Pinkie Pie\nYou chose no!"
    next: => @exitscene -1
  }, {
    txt: "Pinkie Pie\nYou chose hmm?"
    next: => @exitscene -1
  }, {
    txt: "\nYou made Pinkie cry :<"
    next: => @exitscene -1
  }]
