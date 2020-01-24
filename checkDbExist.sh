#!/usr/bin/bash


function checkDB {

    if [ -d $1 ]
    then
        return 1;
    else
        return 0;
    fi
}

# $1 is new database name
checkDB ${DBs_path}/$1