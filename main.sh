#!/usr/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

myDatabasePath=""

DBs_path="/home/onepiece/Downloads/dbEngine-master/DataBases"
# create dataBases directory if not exists
mkdir -p ${DBs_path}

while true
do
    select choice in 'press 1 to list databases' 'press 2 to choose a database' 'press 3 create a new database' 'press 4 to delete database' 'press 5 to Exit'
    do
        i=0
        for folder in ${DBs_path}/*
        do
            databases[$i]=$folder # get all databases in an array
            ((i=$i+1))
        done

        case $REPLY in
        1)
            echo -e "\n"
            echo "******** DataBases **********"
            ls --color ${DBs_path}
            echo "*****************************"
            echo -e "\n"

            break
        ;;
        2)
            while true
            do
                j=0
                for database in ${databases[@]}
                do
                    ((j=$j+1))
                    echo "press $j for ${database/$DBs_path} " # remove path from db name

                done
                echo "Please select a database:"
                read userInput

                if [ ${userInput} -le ${j} -a  ${userInput} -gt 0 ]
                then
                    myDatabasePath="${databases[$userInput]}"
                    echo "You Are Using : ${myDatabasePath/$DBs_path}"
                    PS3="${myDatabasePath/$DBs_path}: "
                    while true
                    do
                        select choice2 in 'insert' 'update' 'delete' 'select' 'display all' 'back to main'
                        do
                            case $REPLY in
                            1) echo "insert"
                               break
                            ;;
                            2) echo "update"
                               break
                            ;;
                            3) echo "delete"
                               break
                            ;;
                            4) echo "select"
                               break
                             ;;
                            5) echo "display all"
                               break
                             ;;
                            6)
                                echo "back to main"
                                PS3="#? "
                                break 2
                             ;;
                            *) break ;;
                            esac
                        done
                        continue 1
                    done
                    break 2 # if user choosed valid db do not make him choose again
                else
                    echo "Invalid database please choose again"
                    continue 1
                fi
            done
        ;;
        3)
            while true
            do
                echo "Enter dataBase name "
                read databaseName
                source createDb.sh ${databaseName}
            done
            break
        ;;
        4)
            echo "Enter dataBase name "
            read databaseName
            source deleteDb.sh ${databaseName}
            break
        ;;
        5)
            echo "${yellow}Bye${reset}"
            break 2
        ;;
        *)
            break
        ;;
        esac

    done
    continue # reload menu
done
