if module?
  assert = require('chai').assert
  expect = require('chai').expect
  evalS = require('../src/scheem').evalScheem
else
  assert = chai.assert
  expect = chai.expect
  evalS = evalScheem

suite 'define, set!', ->
  test '(define a 1)', ->
    env = {}
    evalS(['define', 'a', 1], env)
    assert.deepEqual env['a'], 1
  test '(begin (define a 1) (set! a 2))', ->
    env = {}
    evalS(['begin', ['define', 'a', 1], ['set!', 'a', 2]], env)
    assert.deepEqual env['a'], 2
  test '(set! a 1)', ->
    expect(->
      evalS(['set!', 'a', 1], {})).to.throw()

suite 'comparison', ->
  test '(= 1 1)', ->
    assert.deepEqual evalS(['=', 1, 1], {}), '#t'
  test '(= (+ 1 2) (- 6 3))', ->
    assert.deepEqual evalS(['=', ['+', 1, 2], ['-', 6, 3]], {}), '#t'
  test '(< 2 3)', ->
    assert.deepEqual evalS(['<', 2, 3], {}), '#t'
  test '(< (+ 1 2) (- 6 3))', ->
    assert.deepEqual evalS(['<', ['+', 1, 2], ['-', 6, 3]], {}), '#f'

suite 'quote', ->
  test '(quote 3)', ->
    assert.deepEqual evalS(['quote', 3], {}), 3
  test '(quote \'dog\')', ->
    assert.deepEqual evalS(['quote', 'dog'], {}), 'dog'
  test '(quote (1 2 3))', ->
    assert.deepEqual evalS(['quote', [1, 2, 3]], {}), [1, 2, 3]
  test '(quote (+ 1 2 3))', ->
    assert.deepEqual evalS(['quote', ['+', 1, 2, 3]], {}), ['+', 1, 2, 3]
  test '(quote (quote (+ 1 2 3)))', ->
    assert.deepEqual evalS(['quote', ['quote', ['+', 1, 2, 3]]], {}), ['quote', ['+', 1, 2, 3]]

suite 'begin', ->
  test '(begin 1 2 3)', ->
    assert.deepEqual evalS(['begin', 1, 2, 3], {}), 3
  test '(begin (+ 2 2))', ->
    assert.deepEqual evalS(['begin', ['+', 2, 2]], {}), 4
  test '(begin x y z)', ->
    assert.deepEqual evalS(['begin', 'x', 'y', 'z'], {x:1, y:2, z:3}), 3
  test '(begin (define x 5) (define y 10) (+ x y))', ->
    assert.deepEqual evalS(['begin', ['define', 'x', 5], ['define', 'y', 10], ['+', 'x', 'y']], {}), 15

suite 'cons, car, cdr', ->
  test '(cons 1 (quote 2 3))', ->
    assert.deepEqual evalS(['cons', 1, ['quote', [2, 3]]], {}), [1, 2, 3]
  test '(cons (quote 1 2) (quote 2 3))', ->
    assert.deepEqual evalS(['cons', ['quote', [1, 2]], ['quote', [2, 3]]], {}), [[1, 2], 2, 3]
  test '(car (quote ((1 2) 3 4)))', ->
    assert.deepEqual evalS(['car', ['quote', [[1, 2], 3, 4]]], {}), [1, 2]
  test '(cdr (quote ((1 2) 3 4)))', ->
    assert.deepEqual evalS(['cdr', ['quote', [[1, 2], 3, 4]]], {}), [3, 4]

suite 'if', ->
  test '(if (= 1 1) 2 3)', ->
    assert.deepEqual evalS(['if', ['=', 1, 1], 2, 3], {}), 2
  test '(if (< 1 1) 2 3)', ->
    assert.deepEqual evalS(['if', ['<', 1, 1], 2, 3], {}), 3
