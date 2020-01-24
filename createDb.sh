#!/usr/bin/bash

# make sure user write database name
if [ $# -gt 0 ]
then 	
	source checkSyntax.sh
	syntaxValid=$?
	# database syntax valid
	if [ $syntaxValid -eq 1 ]
	then
        source checkDbExist.sh
        isExisted=$?
        # database already existed
        if [ $isExisted -eq 1 ]
        then
            echo "${red}database already Exists please try another name${reset}"
            continue 1
        else
            mkdir ${DBs_path}/$1
            echo "${green}Database created successfully${reset}"
            break 1
        fi
    else
        echo "${red}Syntax not valid database name must start with letters or _${reset}"
        continue 1
	fi
else
  echo "${red}No database name given${reset}"
  continue 1
fi

