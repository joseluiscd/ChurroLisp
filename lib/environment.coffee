module.exports = class Environment
    constructor: (parent) ->
        @parent = parent
        @env = {}

    get: (name)->
        if name of @env
            return @env[name]
        else if @parent?
            return @parent.get name
        else
            return null

    set: (name, value)->
        @env[name]=value

    extend: (values) ->
        for x,y of values
            @env[x]=y

    sub: ()->
        return new Environment(@)
