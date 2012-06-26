class engine
  constructor: (@rends, scenetree, @screen, keymap) ->
    @keys = {}
    for key of keymap then @keys[key] = {val: keymap[key], poll: 0, state: 0}
    @buffer = new surface @screen.size()
    @buffer.ctx.fillStyle = "#000000"
    @buffer.ctx.strokeStyle = "#ffffff"
    @buffer.ctx.lineWidth = 25
    @buffer.ctx.lineCap = "round"
    @buffer.ctx.globalCompositeOperation = "destination-over"
    scenetree.n.buildtree scenetree.c, 0, 0
    scenetree.n.initialize()
    serv.reset yes

  input: (code, data) ->
    importantkey = no
    for k of @keys
      @keys[k].poll = 0
      for keycode in @keys[k].val when code is keycode
        importantkey = yes
        @keys[k].poll = data
      @keys[k].state = 1 if @keys[k].poll is 1
      @keys[k].state = 0 if @keys[k].poll is -1
    if importantkey then for rend in @rends when rend.input @keys then break
    no

  step: ->
    @screen.drawImage @buffer
    @buffer.clear no
    for rend in @rends when rend.render @buffer then break
    @buffer.clear yes
