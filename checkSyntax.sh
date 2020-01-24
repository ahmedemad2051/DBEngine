#!/usr/bin/bash


function checkSyntax {

    local DATABASE=$1
    # check the DATABASE is  valid!
    DATABASE_PATTERN="^[a-zA-Z_]+[a-zA-Z]+[0-9a-zA-Z_]*$"

    if [[ "$DATABASE" =~ $DATABASE_PATTERN ]]
    then
        return 1
    else
        return 0
    fi
}

# $1 is new database name
checkSyntax $1