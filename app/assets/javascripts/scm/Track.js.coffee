
this.SCM = this.SCM ? {}

class SCM.Track

  constructor: (@pathData) ->

  renderTo: (@paper) ->
    @path = @paper.path @pathData
    @path.attr stroke: "#000", 'stroke-width': 4

