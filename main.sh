#!/usr/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
gray=`tput setaf 8`
reset=`tput sgr0`
ORIGINAL=$LS_COLORS

myDatabasePath=""

DBs_path="/home/$USER/Downloads/dbEngine-master/DataBases"
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
                        echo "${blue}press $j for ${database/$DBs_path} ${reset}" # remove path from db name
                        
                    done
                    echo "Please select a database:"
                    read userInput
                    
                    if [ ${userInput} -le ${j} -a  ${userInput} -gt 0 ]
                    then
                        (( userInput=$userInput-1))
                        myDatabasePath="${databases[$userInput]}"
                        echo "You Are Using : ${myDatabasePath/$DBs_path}"
                        PS3="${myDatabasePath/$DBs_path}: "
                        while true
                        do
                            select choice2 in  'show tables' 'create table' 'delete table' 'select Table' 'back to main'
                            do
                                
                                x=0
                                for file in ${myDatabasePath}/*
                                do
                                    tables[$x]=$file # get all tables in an array
                                    ((x=$x+1))
                                done
                                
                                case $REPLY in
                                    1)
                                        echo -e "\n"
                                        echo "******** All Tables **********"
                                        ls --color ${myDatabasePath}
                                        echo "******************************"
                                        echo -e "\n"
                                        break
                                    ;;
                                    2)
                                        while true
                                        do
                                            echo -e "\n"
                                            echo "******** All Tables **********"
                                            ls --color ${myDatabasePath}
                                            echo "******************************"
                                            echo -e "\n"
                                            echo "Enter new table name "
                                            read tableName
                                            source checkSyntax.sh ${tableName}
                                            if [ $? -eq 1 ]
                                            then
                                                source createTb.sh ${tableName}
                                            else
                                                echo "${red}Syntax not valid. column name must start with letters or _${reset}"
                                            fi
                                        done
                                        break
                                    ;;
                                    3) while true
                                        do
                                            echo -e "\n"
                                            echo "******** All Tables **********"
                                            ls --color ${myDatabasePath}
                                            echo "******************************"
                                            echo -e "\n"
                                            echo "Enter table name "
                                            read tableName
                                            source checkTbExist.sh ${tableName}
                                            if [ $? -eq 1 ]
                                            then
                                                rm -f ${myDatabasePath}/${tableName}
                                                rm -f ${myDatabasePath}/".${tableName}.md"
                                                echo "${green}${tableName} has been deleted succesfully${reset}"
                                                break
                                            else
                                                echo this Table is Not Existed
                                            fi
                                            echo to return to the previous menu press 1
                                            read userInput
                                            if [ $userInput -eq "1" ]
                                            then
                                                break
                                            fi
                                        done
                                        break
                                    ;;
                                    4) echo "select"
                                        while true
                                        do
                                            k=0
                                            for table in ${tables[@]}
                                            do
                                                ((k=$k+1))
                                                echo "${blue}press $k for ${table/$myDatabasePath} ${reset}" # remove path from db name
                                            done
                                            echo "Please select a table:"
                                            read tableUserInput
                                            
                                            if [ ${tableUserInput} -le ${k} -a  ${tableUserInput} -gt 0 ]
                                            then
                                                (( tableUserInput=$tableUserInput-1))
                                                arrayTableName="${tables[$tableUserInput]}"
                                                tableName=$(echo "${tables[$tableUserInput]}" | rev | cut -d'/' -f 1 | rev)
                                                echo "You Are Using : ${arrayTableName/$myDatabasePath}"
                                                PS3="${arrayTableName/$myDatabasePath}: "
                                                while true
                                                do
                                                    select choice2 in  'insert into table' 'update table' 'delete row in table' 'display all' 'add column to table' 'drop column from table' 'back to main'
                                                    do
                                                        case $REPLY in
                                                            1) echo "insert"
                                                                source insertIntoTable.sh ${tableName}
                                                                break
                                                            ;;
                                                            2) echo "update"
                                                                source updateIntoTable.sh ${tableName}
                                                                break
                                                            ;;
                                                            3) echo "delete"
                                                                source deleteRowFromTable.sh ${tableName}
                                                                break
                                                            ;;
                                                            4)
                                                                source displayAll.sh ${tableName}
                                                                break
                                                            ;;
                                                            5) echo "update Data Of The Table"
                                                                source updateMetaData.sh ${tableName}
                                                                break
                                                            ;;
                                                            6) echo "delete column from table"
                                                                source dropColumn.sh ${tableName}
                                                                break
                                                            ;;
                                                            7)
                                                                echo "back to main"
                                                                PS3="#? "
                                                                break 3
                                                            ;;
                                                            *) break ;;
                                                        esac
                                                    done
                                                done
                                            else
                                                echo "Invalid table please choose again"
                                                continue 1
                                            fi
                                        done
                                        break
                                    ;;
                                    5)
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
                    source checkSyntax.sh ${databaseName}
                    if [ $? -eq 1 ]
                    then
                        source createDb.sh ${databaseName}
                    else
                        echo "${red}Syntax not valid. column name must start with letters or _${reset}"
                    fi
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
