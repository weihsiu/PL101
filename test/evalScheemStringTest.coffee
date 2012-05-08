if module?
  assert = require('chai').assert
  newE = require('../src/scheem').newEnv
  evalScheemStr = require('../src/scheem').evalScheemString
else
  assert = chai.assert
  newE = newEnv
  evalScheemStr = evalScheemString

suite 'eval scheem string', ->
  test '(+ 2 (* 3 4))', ->
    assert.deepEqual evalScheemStr('(+ 2 (* 3 4))', newE()), 14
  test '(begin (define a 1) (if (= a 1) 2 3))', ->
    assert.deepEqual evalScheemStr('(begin (define a 1) (if (= a 1) 2 3))', newE()), 2
  test "(begin (define a '(1 2 3)) (if (< (car a) (car (cdr a))) 4 5))", ->
    assert.deepEqual evalScheemStr("(begin (define a '(1 2 3)) (if (< (car a) (car (cdr a))) 4 5))", newE()), 4
  test '(let-one x 1 (+ x 2))', ->
    assert.deepEqual evalScheemStr("(let-one x 1 (+ x 2))", newE()), 3
  test '(begin (define plusone (lambda-one x (+ x 1))) (plusone 10))', ->
    assert.deepEqual evalScheemStr('(begin (define plusone (lambda-one x (+ x 1))) (plusone 10))', newE()), 11
  test '(begin (define add (lambda (x y) (+ x y))) (add 1 2))', ->
    assert.deepEqual evalScheemStr('(begin (define add (lambda (x y) (+ x y))) (add 1 2))', newE()), 3
  test '((lambda (x) (* x x)) 2)', ->
    assert.deepEqual evalScheemStr('((lambda (x) (* x x)) 2)', newE()), 4
  test '((lambda (f) (f 2)) (lambda (x) (+ x 4)))', ->
    assert.deepEqual evalScheemStr('((lambda (f) (f 2)) (lambda (x) (+ x 4)))', newE()), 6
  test '((lambda (x) ((lambda (y) (+ x y)) 2)) 3)', ->
    assert.deepEqual evalScheemStr('((lambda (x) ((lambda (y) (+ x y)) 2)) 3)', newE()), 5
  test '((lambda (x) (+ x 10)) 10)', ->
    assert.deepEqual evalScheemStr('((lambda (x) (+ x 10)) 10)', newE(x: 1)), 20
  test '((lambda () (set! x 10)))', ->
    env = newE(x: 1)
    evalScheemStr('((lambda () (set! x 10)))', env)
    assert.deepEqual env.bindings, x: 10
  test '((lambda (x) (begin ((lambda (y) (set! x y)) 3) x)) 2)', ->
    assert.deepEqual evalScheemStr('((lambda (x) (begin ((lambda () (set! x 3))) x)) 2)', newE()), 3
  test '(((lambda (x) (lambda (y) (+ x y))) 2) 3)', ->
    assert.deepEqual evalScheemStr('(((lambda (x) (lambda (y) (+ x y))) 2) 3)', newE()), 5
  test '(begin (define fact (lambda (n) (if (= n 0) 1 (* n (fact (- n 1)))))) (fact 10))', ->
    assert.deepEqual evalScheemStr('(begin (define fact (lambda (n) (if (= n 0) 1 (* n (fact (- n 1)))))) (fact 10))', newE()), 3628800
  test "(alert 'hello)", ->
    evalScheemStr("(alert 'hello)", newE())