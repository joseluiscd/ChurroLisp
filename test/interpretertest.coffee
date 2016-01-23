Interpreter = require("../lib/interpreter")

main = ->
    a = new Interpreter()
    console.log a.exec(["if", true, ["list", 2, ["if", false, 9, 0], 5], 5])

main()
