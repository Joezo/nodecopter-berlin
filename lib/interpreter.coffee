module.exports = class Interpreter
  commandRegExes   : {}
  directionRegExes : {}

  directions:
    left:
      text: ['left']
    right:
      text: ['right']
    front:
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
    rotate:
      params: ['direction', 'duration']
      text: ['rotate', 'turn']
  
  constructor: (@drone) ->
    throw new Error("I need a drone!") unless @drone

    for command, obj of @commands
      reg = "(#{obj.text.join('|')})"
      reg += '\\s([\\w]+)'                    if obj.params and 'direction' in obj.params
      reg += '\\sfor\\s([0-9]+)\\ssecond(s?)' if obj.params and 'duration' in obj.params

      @commandRegExes[command] = RegExp reg

    for direction, obj of @directions
      @directionRegExes[direction] = "(#{obj.text.join('|')})"

  interpret: (text) ->
    for command, expression of @commandRegExes
      if matches = expression.exec text
        if params = @_matchParams(command, matches)
          return @[command](params...)
        else
          return @[command]()
    return false

  fly: (direction, duration=1) ->
    console.log("flying #{direction} for #{duration}")
    @drone.after(0, ->
      @[direction](0.2)
    ).after(duration * 1000, ->
      @stop()
    )
    return true

  rotate: (direction, duration) ->
    
  flip: (direction) ->
    switch direction
      when 'left'
        @drone.animate('flipLeft', 1500)        
      when 'right'
        @drone.animate('flipRight', 1500)
      when 'front'
        @drone.animate('flipAhead', 1500)
      when 'back'
        @drone.animate('flipBehind', 1500)
      else
        return false
    return true        
    
  stop: ->
    console.log('Stop')
    @drone.stop()
    true
   
  takeoff: ->
    console.log('Taking off')
    @drone.takeoff()
    true
    
  land: ->
    console.log('Land')
    @drone.land()
    true
    
  _matchParams: (command, matches) ->
    return null if typeof @commands[command].params is 'undefined'
    params = for paramName, index in @commands[command].params
      switch paramName
        when 'direction'
          @_matchDirection(matches[index+2])
        when 'duration'
          parseInt matches[index+2], 10
    return params
    
  _matchDirection: (text) ->
    for direction, expression of @directionRegExes
      return direction if expression.match text
    return false

