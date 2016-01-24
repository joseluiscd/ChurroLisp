# ChurroLisp Interpreter


Here we define the basic interpreter of ChurroLisp. First of all, we import the
parser that Jison generated for us:

    parser = require("./churrolisp")
    {Value, Variable}= require("./tokens")
    parser.parser.yy = require("./tokens")
    Environment = require("./environment")

    console.log parser


    module.exports = class Interpreter
        globalenv: new Environment
        defaultFuncs: {
            #"list": (i, env, args...) -> return args
            "declare": (i, env, args...) -> env.set name, null
            "set": (i, env, name, value) -> env.set name, value
            "var": (i, env, name) -> return env.get name
            "if": (i, env, cond, t, f) ->
                if cond
                    i.evaluate t, env.sub()
                else
                    i.evaluate f, env.sub()

            "+": (i, env, a, b) -> return i.evaluate a,env + i.evaluate b,env
            "list": (i, env, expressions...) ->
                newenv = env.sub()
                a = for x in expressions
                    i.evaluate x, newenv
                return a

            "print": (i, env, expression) -> console.log i.evaluate expression,env

            "seq": (i, env, expressions...) -> #Sequential
                ret=null
                newenv = env.sub()
                for x in expressions
                    ret = i.evaluate x, newenv
                return ret

            "co": (i, env, expressions...) -> #Concurrent (""Concurrent"")
                ret = null
                newenv = env.sub()
                for x in expressions
                    process.nextTick i.evaluate x, newenv
                return ret

        }

        constructor: (otherEnv)->
            @globalenv.extend @defaultFuncs
            console.log @globalenv
            if otherEnv?
                @globalenv.extend otherEnv

## Load
**Input**: A string with the *Lisp* expression.
**Output**: The JavaScript list with the parsed expression.

        load: (str) ->
            a=parser.parser.parse(str)
            return a

## Evaluate
This is the recursive function that will evaluate an expression
**Input**: A list containing things to be evaluated. The environment as an object.
**Output**: What the list would return

        evaluate: (list, env) ->
            console.log "Evaluating #{list}"
            if typeof list is "object"
                if list instanceof Variable
                    #We have to evaluate the variable in the current environment
                    return env.get list.name
                if list instanceof Array and list.length isnt 0
                    #This is a function!!!
                    if list[0] instanceof Variable then return @call list[0].name, list[1..], env
                    else
                        newenv = env.sub()
                        return [@evaluate x, newenv for x in list]
                else
                    return null
            else
                return list

## Exec
Execute the code in the interpreter with the global environment
**Input**: Some code to execute
**Output**: What the code returns

        exec: (list) ->
            @evaluate list, @globalenv


## Call
In this function, we choose the coffeescript function to call with the given expression.
**Input**: The function name, the arguments, and the environment
**Output**: The value returned by the wrapped function

        call: (name, args, env) ->
            if typeof (a = env.get name) is "function"
                return a @, env, args...
