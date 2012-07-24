iscene = new scenenode ["img/tiles","img/pinkiepie","img/pinkiepie","img/pinkiepie","snd/scene1"],
  -> serv.inscenemgr.initialize [
    new sprite
      area : new rect 51, 1368, 96, 96
      len : [0, 1, 7, 13]
      speed : [0, 3, 9]
      active : yes
      vector : (new angle "spr", 2)
      sheet : @file[1]
      aiscripts :
        input : serv.getai.keyboard()
    new sprite
      area : new rect 1823, 109, 96, 96
      len : [0, 1, 7, 13]
      speed : [0, 3, 9]
      solid : yes
      active : yes
      vector : (new angle "spr", -1)
      sheet : @file[2]
      aiscripts :
        frame : serv.getai.follow 100, 150, 200
        interact : (subject, object) =>
          @child[1].initialize()
    new sprite
      area : new rect 1013, 661, 96, 96
      len : [0, 1, 7, 13]
      speed : [0, 3, 9]
      solid : yes
      sheet : @file[3]
      aiscripts :
        interact : (subject, object) =>
          subject.vector.set "pts", subject.area.p, object.area.p
          @child[0].initialize()
    new tileset (new vect 100, 100), @file[0], (@file[4].init 0, 15), "#000000", [
      [-7,-7,-7,-7,-7,1,2,3,-7,1,18,26,16,3,-7,1,2,2,2,3]
      [-7,16,17,3,-7,27,12,9,-7,10,14,12,15,8,-7,27,12,12,12,8]
      [24,15,12,22,-7,6,12,14,2,15,12,12,12,13,-7,11,12,12,12,13]
      [-7,21,12,22,-7,6,12,4,-7,-7,20,19,-7,-7,-7,-7,5,4,-7,-7]
      [-7,-7,5,22,-7,6,12,8,-7,1,15,14,2,3,-7,-7,10,9,-7,-7]
      [-7,-7,10,9,-7,10,12,8,-7,27,12,12,12,8,-7,1,15,14,2,3]
      [-7,24,15,14,2,15,12,8,-7,27,12,12,12,8,-7,11,12,12,12,13]
      [-7,-7,-7,-7,-7,5,12,8,-7,11,12,12,12,13,-7,-7,-7,5,4,-7]
      [-7,-7,-7,-7,-7,10,12,9,-7,-7,-7,-7,-7,-7,-7,-7,-7,10,22,-7]
      [1,2,2,17,2,15,12,14,2,2,2,17,17,2,2,2,2,15,22,-7]
      [6,12,12,12,12,23,-7,21,12,12,12,12,12,12,12,12,12,12,9,-7]
      [6,12,12,12,19,-7,-7,-7,20,4,-7,-7,-7,5,4,-7,-7,5,14,29]
      [6,12,12,12,14,18,-7,16,15,9,-7,-7,-7,10,9,-7,-7,10,12,29]
      [6,4,-7,-7,5,14,2,15,12,14,17,2,2,15,14,2,2,15,4,-7]
      [11,13,-7,-7,11,12,12,12,12,12,12,23,-7,28,28,-7,21,12,13,-7]
    ]
  ]
