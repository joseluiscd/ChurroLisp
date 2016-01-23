# ChurroLisp Interpreter
_Code isn't tested yet, so run it at your own risk :wink:_

Here we define the basic interpreter of ChurroLisp. First of all, we import the
parser that Jison generated for us:

    parser = require("./churrolisp")
    module.exports = class Interpreter
        globalenv: {
            "list": (i, env, args...) -> return args
            "var": (i, env, name) -> return env[name]
            "set": (i, env, name, value) -> env[name]=value
            "if": (i, env, cond, t, f) -> return if cond then t else f
            "+": (i, env, a, b) -> return a+b

            "seq": (i, env, expressions...) ->
                ret=null
                for x in expressions
                    ret = i.evaluate x, env
            "co": (i, env, expressions...) ->
                ret = null
                
        }


## Load
**Input**: A string with the *Lisp* expression.
**Output**: The JavaScript list with the parsed expression.

        load: (str) ->
            parser.parse(str)

## Evaluate
This is the recursive function that will evaluate an expression
**Input**: A list containing things to be evaluated. The environment as an object.
**Output**: What the list would return

        evaluate: (list, env) ->
            if typeof list is "object"
                if list.length isnt 0
                    switch typeof list[0]
                        when "string" then return @call list[0], (@evaluate x, env for x in list[1..]), env
                        ## Add more
                        else return list[0]

                else
                    return null
            else
                return list

## Exec
Execute the code in the interpreter

        exec: (list) ->
            @evaluate list, @globalenv


## Call
In this function, we choose the coffeescript function to call with the given expression.
**Input**: The function name, the arguments, and the environment
**Output**: The value returned by the wrapped function

        call: (name, args, env) ->
            if typeof env[name] is "function"
                return env[name](@, env, args...)

## Clone
Helper function to clone environments
**Input** An environment
**Output** The clone of the environment

        clone: (env) ->
            toRet = new env.constructor()
            for x of env
                toRet[x]=env[x]
            return toRet
