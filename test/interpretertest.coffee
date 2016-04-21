Interpreter = require "../lib/interpreter"
expect = require("chai").expect

describe "compiler", ->
    it "compiles simple statements", (done)->
        lisp = new Interpreter()
        f="(if 1 5 7)"
        x = lisp.load f
        console.log x

        expect(x).to.deep.equal [{name: "if"}, 1, 5, 7]
        done()
