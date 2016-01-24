Interpreter = require("../lib/interpreter")

main = ->
    a = new Interpreter()

    f="(if 1 (list 2 (if 0 9 0) 5) 5)"
    f = a.load f


    console.log a.exec f
main()
