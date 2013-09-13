assert      = require('assert')
sinon       = require('sinon')
Interpreter = require('../lib/interpreter')

describe 'The Intepreter', ->
  describe 'interpret', ->
    describe 'takeoff', ->
      beforeEach ->
        @interpreter = new Interpreter('drone')
        sinon.stub(@interpreter, 'takeoff')

      it 'parses takeoff', ->
        @interpreter.interpret('takeoff')
        sinon.assert.called(@interpreter.takeoff)
      
      it 'parses take off', ->
        @interpreter.interpret('take off')
        sinon.assert.called(@interpreter.takeoff)

    describe 'land', ->
      beforeEach ->
        @interpreter = new Interpreter('drone')
        sinon.stub(@interpreter, 'land')
      
      it 'parses land', ->
        @interpreter.interpret('land')
        sinon.assert.called(@interpreter.land)

    describe 'rotate', ->
      beforeEach ->
        @interpreter = new Interpreter('drone')
        sinon.stub(@interpreter, 'rotate')

      it 'parses rotate', ->
        @interpreter.interpret('rotate left for 15 seconds')
        sinon.assert.calledWith(@interpreter.rotate, 'left', 15)
      
      it 'parses turn', ->        
        @interpreter.interpret('turn right for 11 seconds')
        sinon.assert.calledWith(@interpreter.rotate, 'right', 11)

      it 'parses left', ->                
        @interpreter.interpret('rotate left for 1 second')
        sinon.assert.calledWith(@interpreter.rotate, 'left' , 1)

      it 'parses right' , ->                
        @interpreter.interpret('rotate right for 2 second')
        sinon.assert.calledWith(@interpreter.rotate, 'right' , 2)
    
    

    describe 'fly', ->
      beforeEach ->
        @interpreter = new Interpreter('drone')
        sinon.stub(@interpreter, 'fly')

      describe 'left', ->
        it 'parses left', ->
          @interpreter.interpret('fly left for 10 seconds')
          sinon.assert.calledWith(@interpreter.fly, 'left', 10)
  
      describe 'right', ->
        it 'parses right', ->
          @interpreter.interpret('fly right for 10 seconds')
          sinon.assert.calledWith(@interpreter.fly, 'right', 10)
    
      describe 'forward', ->
        it 'parses forward', ->
          @interpreter.interpret('fly forward for one second')
          sinon.assert.calledWith(@interpreter.fly, 'front', 1)
    
        it 'parses forwards', ->
          @interpreter.interpret('fly forwards for 10 seconds')
          sinon.assert.calledWith(@interpreter.fly, 'front', 10)
    
      describe 'back', ->
        it 'parses back', ->
          @interpreter.interpret('fly back for 10 seconds')
          sinon.assert.calledWith(@interpreter.fly, 'back', 10)
    
      describe 'up', ->
        it 'parses up', ->
          @interpreter.interpret('fly up for 10 seconds')
          sinon.assert.calledWith(@interpreter.fly, 'up', 10)
    
      describe 'down', ->
        it 'parses down', ->
          @interpreter.interpret('fly down for 10 seconds')
          sinon.assert.calledWith(@interpreter.fly, 'down', 10)
      
      describe 'invalid direction', ->
        it 'returns false', ->
          assert @interpreter.interpret('fly around for 40 seconds') is false
          
  
  # describe 'fly', ->
  #   beforeEach ->
  #     class Drone
  #       after: ->
  #       left: ->
  #     @drone = new Drone
  #     sinon.stub(@drone, 'after').returns(@drone)
  #     sinon.stub(@drone, 'left').returns(@drone)
  #     @interpreter = new Interpreter(@drone)
  #   
  #   it 'calls left', ->
  #     @interpreter.fly('left', 10)
  #     sinon.assert.called(@drone.left)
