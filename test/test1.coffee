chai = require 'chai'
chai.should()

stackval = require '../lib'

describe 'stackval', ->

  it 'should store an upstack value and make it available to downstack functions', ->
    v1 = stackval()
    funca = -> v1.get().should.equal 'foo'
    funcb = -> funca()
    funcb = v1.attach funcb, -> 'foo'
    funcb()

  it 'should work using shortcut get: f() --> f.get()', ->
    v1 = stackval()
    funca = -> v1().should.equal 'foo'
    funcb = -> funca()
    funcb = v1.attach funcb, -> 'foo'
    funcb()

  it 'should work using shortcut attach: f(x,y) --> f.attach(x,y)', ->
    v1 = stackval()
    funca = -> v1().should.equal 'foo'
    funcb = -> funca()
    funcb = v1 funcb, -> 'foo'
    funcb()

  it 'should accept different nested values ( downstack values override upstack values )', ->
    v1 = stackval()
    inner = -> v1.get().should.equal 'inner'
    inner = v1.attach inner, -> 'inner'
    outer = ->
      v1.get().should.equal 'outer'
      inner()
      v1.get().should.equal 'outer'
    outer = v1.attach outer, -> 'outer'
    outer()

  it '.defined() should return true when an upstack value is available', ->
    v1 = stackval()

    # read foo in a downstack function
    funca = ->
      v1().should.equal 'foo'
      v1.defined().should.equal yes
    
    # an intermediate function. just to test nesting
    funcb = -> funca()
    
    # attach 'foo' to an upstack function
    funcb = v1 funcb, -> 'foo'
    
    # run the upstack function
    funcb()


  it '.defined() should return false when there is no upstack value available', ->
    v1 = stackval()

    # read foo in a downstack function
    funca = ->
      v1.should.throw()
      v1.defined().should.equal no
    
    # an intermediate function. just to test nesting
    funcb = -> funca()
    
    # attach 'foo' to an upstack function
    # funcb = v1 funcb, -> 'foo'
    
    # run the upstack function
    funcb()

