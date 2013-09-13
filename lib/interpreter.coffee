module.exports = class Interpreter
  regexes: {}

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

    for method, command of @commands
      reg = "(#{command.text.join('|')})"
      reg += '\\s([\\w]+)'                 if command.params and 'direction' in command.params
      reg += '\\sfor\\s([0-9]+)\\sseconds' if command.params and 'duration' in command.params

      @regexes[method] = RegExp reg

  interpret: (text) ->
    for method, expression of @regexes
      if matches = expression.exec text
        return @[method](matches[2], matches[3])
    return false

  fly: (direction, duration=1) ->
    return unless direction in ['left', 'right', 'forward', 'back']
    @drone[direction](0.2)
      .after duration * 1000, ->
        @stop()

  rotate: (direction, duration) ->
    
  flip: (direction) ->
    
  stop: ->
    
  takeoff: ->
    
  land: ->
