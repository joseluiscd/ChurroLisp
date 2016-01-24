Interpreter = require("../lib/interpreter")

main = ->
    a = new Interpreter()

    f="(if 1 (list 2 (if 0 9 0) 5) 5)"
    f = a.load f


    console.log a.exec f

    x = """
    (seq
        (set a 4)
        (set b 5)
        (seq
            (print (var a))
            (set x 5)
        )
        (print (var x))
    )
    """

    x = a.load x
    console.log a.exec x
main()
