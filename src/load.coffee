# **The loading screen.**
#
# In a non-blocking loading environment such as a web browser, a resource
# might potentially be used before it's fully loaded. This class attempts
# to counteract this problem.  
# External resources should be added to the list, and should be set to remove
# themselves from the list once they finish loading. This layer blocks the
# stack while objects remain in the list, and displays a progress bar showing
# the number of resources already loaded out of the total number of resources.
class loader
  constructor: ->
    @loadcount = []
    @maxload = 0

  # Draw a loading bar on the screen.  
  # Block if something is being loaded.
  render: (buffer) ->
    if @loadcount.length isnt 0
      @maxload = @loadcount.length if @maxload < @loadcount.length
      loadwidth = (@maxload - @loadcount.length)*(buffer.dims.x - 60)/@maxload
      buffer.ctx.beginPath()
      buffer.ctx.moveTo 30, buffer.dims.y - 30
      buffer.ctx.lineTo loadwidth + 30, buffer.dims.y - 30
      buffer.ctx.stroke()
    else @maxload = 0
    @loadcount.length isnt 0

  # Block if something is being loaded.
  input: (keys) -> @loadcount.length isnt 0
