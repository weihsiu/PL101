if module?
  assert = require('chai').assert
  evalScheemStr = require('../src/scheem').evalScheemString
else
  assert = chai.assert
  evalScheemStr = evalScheemString

suite 'eval scheem string', ->
  test '(+ 2 (* 3 4))', ->
    assert.deepEqual evalScheemStr('(+ 2 (* 3 4))', {}), 14
  test '(begin (define a 1) (if (= a 1) 2 3))', ->
    assert.deepEqual evalScheemStr('(begin (define a 1) (if (= a 1) 2 3))', {}), 2
  test "(begin (define a '(1 2 3)) (if (< (car a) (car (cdr a))) 4 5))", ->
    assert.deepEqual evalScheemStr("(begin (define a '(1 2 3)) (if (< (car a) (car (cdr a))) 4 5))", {}), 4