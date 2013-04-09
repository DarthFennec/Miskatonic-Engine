# **The external scene loader.**
#
# It is generally best to import scenes and cutscenes from external files,
# rather than hardcoding them directly into the engine. Provide a simple
# plaintext loader for this purpose, and provide means of interpreting text
# files and presenting them to the engine as scenenodes.
class extscene
  constructor: ->
    serv.load.filetype["txt/"] = (url) ->
      data = txt: ""
      newf = new XMLHttpRequest
      serv.load.loadcount.push newf
      newf.open "GET", url, true
      newf.onreadystatechange = -> if newf.readyState is 4
        serv.load.err newf, url if newf.status is 404
        if newf.status is 200
          data.txt = newf.responseText
          serv.load.finish newf
      newf.send()
      data

  # Interpret file contents, and return a scenenode object. Scene data is
  # plaintext, and formatted in json. The specific layout depends on the
  # kind of scenenode.
  setscene: (str, sys) ->
    file = JSON.parse str
    type = ""
    for i in file.c then if i.l? and i.t is "t" then type = i.l
    sys ?=
      if type is "out" then serv.outscenemgr
      else if type is "in" then serv.inscenemgr
      else serv.cutscenemgr
    new scenenode file.k, file.f, ->
      list = for i in file.c then switch i.t
        when "t" then serv.extern.settile this, i
        when "s" then serv.extern.setsprite this, i
        else serv.extern.setcutscene this, i
      sys.initialize list

  # Interpret [tileset objects](tile.html) from json.
  settile: (_this, i) ->
    i.c ?= "#000000"
    if i.a?
      snd = @file _this, i.a
      snd.loop = i.d if i.d?
    else snd = 0
    new tileset (new vect i.s[0], i.s[1]), (@file _this, i.i), i.p, snd, i.c, i.m

  # Interpret [sprite objects](sprite.html) from json.
  setsprite: (_this, i) ->
    ps = aiscripts: {}
    for p of i then switch p
      when "vector" then ps.vector = (new angle "spr", i.vector)
      when "sheet" then ps.sheet = @file _this, i.sheet
      when "area", "carea"
        ps[p] = new rect i[p][0], i[p][1], i[p][2], i[p][3]
      else
        if (p.substr 0, 3) is "ai-"
          ps.aiscripts[p.substr 3] = serv.getai[i[p][0]] (i[p].slice 1)...
        else ps[p] = i[p]
    new sprite ps

  # Interpret [cutscene frame objects](cutscene.html) from json.
  setcutscene: (_this, i) ->
    ps = {}
    for p of i
      if i[p] is -1 then ps[p] = -1
      else switch p
        when "snd"
          if typeof i.snd[0] is "number" then ps.snd = @file _this, i.snd
          else
            ps.snd = @file _this, i.snd[0]
            ps.snd.loop = i.snd[1]
        when "next"
          if typeof i.next is "number" then ps.next = i.next
          else ps.next = @setfunction i.next, "k", _this
        when "elem" then ps.elem = for q in i.elem
          new particle (@file _this, q[0]), @setfunction q[1], "t", _this
        when "overlay"
          if typeof i.overlay[0] isnt "string" then ps.overlay = new sequence i.overlay
          else ps.overlay = new gradient i.overlay[0], i.overlay[1], i.overlay[2]
        else ps[p] = i[p]
    ps

  # Interpret functions from json. There is no reason to avoid eval in this
  # case, as all text being evaluated is loaded from the server. Also, it
  # would be extremely difficult to implement something like this without eval.
  setfunction: (_func, _arg, _this) ->
    _func = (_func.split /\bthis\b/gm).join "_this"
    _f = (_func.split ";").filter (x) -> x isnt ""
    _f.push "return (" + _f.pop() + ")"
    eval "(function (" + _arg + "){" + (_f.join ";") + ";})"

  # Help with file selection given nested/ranged files.
  file: (_this, f) ->
    rtn = _this.file
    rtn = rtn[n] for n in f
    rtn
