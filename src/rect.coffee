class rect
  constructor: (@x, @y, @w, @h) ->

  size: -> new vect @w, @h

class vect
  constructor: (@x, @y) ->
