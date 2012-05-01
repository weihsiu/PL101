if module?
  assert = require('chai').assert
  peg = require 'pegjs'
  fs = require 'fs'
  parse = peg.buildParser(fs.readFileSync('src/scheem.pegjs', 'utf-8')).parse
  evalS = require('../src/scheem').evalScheem
else
  assert = chai.assert
  parse = Scheem.parse
  evalS = evalScheem

assertParse = (text, expr) -> assert.deepEqual parse(text), expr

suite 'parse', ->
  test '(a b c)', ->
    assertParse "(a b c)", ["a", "b", "c"]
  test '\n\n(  a  b  c\t\t)\r\r', ->
    assertParse "\n\n(  a  b  c\t\t)\r\r", ["a", "b", "c"]
  test '\'a', ->
    assertParse "'a", ["quote", "a"]
  test '\'(a b c)', ->
    assertParse "'(a b c)", ["quote", ["a", "b", "c"]]
  test '(a \'b \'(c))', ->
    assertParse "(a 'b '(c))", ["a", ["quote", "b"], ["quote", ["c"]]]
  test 'a ;; hello', ->
    assertParse "a ;; hello", "a"
  test '(a ;; hello\nb)', ->
    assertParse "(a ;; hello\nb)", ["a", "b"]
  test ';; hello\n;; world\n(a b c)', ->
    assertParse ";; hello\n;; world\n(a b c)", ["a", "b", "c"]
  test '(1 2 3)', ->
    assertParse "(1 2 3)", [1, 2, 3]
