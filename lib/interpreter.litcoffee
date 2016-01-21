# ChurroLisp Interpreter

Here we define the basic interpreter of ChurroLisp. First of all, we import the
parser that Jison generated for us:

    parser = require("./churrolisp")
    module.exports = class Interpreter

## Load
**Input**: A string with the *Lisp* expression.
**Output**: The JavaScript list with the parsed expression.

        load: (str) ->
            parser.parse(str)
