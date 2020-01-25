#!/usr/bin/bash


function checkSyntax {

    local name=$1
    # check the name is  valid!
    NAME_PATTERN="^[a-zA-Z_]+[a-zA-Z]+[0-9a-zA-Z_]*$"

    if [[ "$name" =~ $NAME_PATTERN ]]
    then
        return 1
    else
        return 0
    fi
}

# $1 is new database/table name
checkSyntax $1