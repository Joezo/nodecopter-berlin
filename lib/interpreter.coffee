module.exports = class Interpreter
  commandRegExes    : {}
  directionRegExes : {}

  directions:
    left:
      text: ['left']
    right:
      text: ['right']
    forward:
      text: ['forward','forwards']
    back:
      text: ['back','backwards']
    up:
      text: ['up']
    down:
      text: ['down']

  commands:
    fly:
      params: ['direction', 'duration']
      text: ['fly']
    takeoff:
      text: ['takeoff', 'take\\ off', 'start']
    land:
      text: ['land']
    reset:
      text: ['reset']
  
  constructor: (@drone) ->
    throw new Error("I need a drone!") unless @drone

    for command, obj of @commands
      reg = "(#{obj.text.join('|')})"
      reg += '\\s([\\w]+)'                 if obj.params and 'direction' in obj.params
      reg += '\\sfor\\s([0-9]+)\\sseconds' if obj.params and 'duration' in obj.params

      @commandRegExes[command] = RegExp reg

    for direction, obj of @directions
      @directionRegExes[direction] = "(#{obj.text.join('|')})"

  interpret: (text) ->
    for command, expression of @commandRegExes
      if matches = expression.exec text
        params = @_matchParams(command, matches)
        return @[command](params...)
    return false

  fly: (direction, duration=1) ->
    return unless direction in ['left', 'right', 'forward', 'back']
    @drone[direction](0.2)
      .after duration * 1000, ->
        @stop()
    return true

  rotate: (direction, duration) ->
    
  flip: (direction) ->
    
  stop: ->
    
  takeoff: ->
    
  land: ->
    
  _matchParams: (command, matches) ->
    return null if typeof @commands[command].params is 'undefined'
    params = []
    for paramName, index in @commands[command].params
      params.push @_matchDirection(matches[index+2]) if paramName is 'direction'
      params.push parseInt(matches[index+2],10) if paramName is 'duration'
    params
    
  _matchDirection: (text) ->
    for direction, expression of @directionRegExes
      return direction if expression.match text
    return false

