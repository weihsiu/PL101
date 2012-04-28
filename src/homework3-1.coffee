peg = require "pegjs"
assert = require "assert"
fs = require "fs"

grammar = fs.readFileSync "scheem.pegjs", "utf-8"
console.log grammar
parse = peg.buildParser(grammar).parse

assertParse = (text, expr) -> assert.deepEqual parse(text), expr

assertParse "(a b c)", ["a", "b", "c"]
assertParse "\n\n(  a  b  c\t\t)\r\r", ["a", "b", "c"]
assertParse "'a", ["quote", "a"]
assertParse "'(a b c)", ["quote", ["a", "b", "c"]]
assertParse "(a 'b '(c))", ["a", ["quote", "b"], ["quote", ["c"]]]
assertParse "a ;; hello", "a"
assertParse "(a ;; hello\nb)", ["a", "b"]
assertParse "  ;; hello\n;; world\n(a b c)", ["a", "b", "c"]