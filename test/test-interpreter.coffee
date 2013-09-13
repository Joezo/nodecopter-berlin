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
        @interpreter.interpret('rotate')
        sinon.assert.called(@interpreter.rotate)
      
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
          @interpreter.interpret('fly forward for 10 seconds')
          sinon.assert.calledWith(@interpreter.fly, 'forward', 10)
    
        it 'parses forwards', ->
          @interpreter.interpret('fly forwards for 10 seconds')
          sinon.assert.calledWith(@interpreter.fly, 'forward', 10)
    
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
