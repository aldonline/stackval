chai = require 'chai'
chai.should()

stackval = require '../lib'

describe 'stackval', ->
  it 'should work', ->
    v1 = stackval()
    funca = -> v1.get().should.equal 'foo'
    funcb = -> funca()
    funcb = v1.attach funcb, -> 'foo'
    funcb()

  it 'should work using shortcut form', ->
    v1 = stackval()
    funca = -> v1().should.equal 'foo'
    funcb = -> funca()
    funcb = v1.attach funcb, -> 'foo'
    funcb()

  describe 'nested stackval', ->
    it 'should work', ->
      v1 = stackval()
      inner = -> v1.get().should.equal 'inner'
      inner = v1.attach inner, -> 'inner'
      outer = ->
        v1.get().should.equal 'outer'
        inner()
        v1.get().should.equal 'outer'
      outer = v1.attach outer, -> 'outer'
      outer()