#!/usr/bin/bash


if [ $# -gt 0 ]
then 	
	source checkDbExist.sh
	isExisted=$?
	if [ ${isExisted} -eq 1 ]
	then 
		rm -r ${DBs_path}/$1
		echo "${green}Db $1 deleted${reset}"
    else
		echo "${red}Db $1 not found${reset}"
	fi
	
fi
