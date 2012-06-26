pausescreen = [{
  txt: ";;Continue;Options;Save Game;Quit Game"
  next: (k) -> switch k
    when 0 then -1
    when 2 then (if serv.save.cansaveload then serv.save.savestate 2 else 5)
    else k
}, {
  txt: "    This will be implemented soon."
  next: 0
}, {
  txt: "    Your progress has been saved."
  next: -1
}, {
  txt: ";    Are you sure you want to quit?#;Yes;No"
  next: (k) -> if k is 0 then 4 else -1
}, {
  len: 50
  overlay: new gradient "#000000", 50, true
  txt: -1
  next: ->
    serv.pausemgr.display.clear yes
    serv.reset yes
    -1
}, {
  txt: "Your browser does not support this feature."
  next: 0
}]
