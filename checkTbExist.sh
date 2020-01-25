#!/usr/bin/bash


function checkTB {

    if [ -f $1 ]
    then
        return 1;
    else
        return 0;
    fi
}

# $1 is new database name
checkTB ${myDatabasePath}/$1