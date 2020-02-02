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
    select choice in 'press 1 to list databases' 'press 2 to choose a database' 'press 3 create a new database' 'press 4 to delete database' "${blue}press 5 to Exit${reset}"
    do
        databaseExistCheck=$(ls ${DBs_path}/)
        l=0
        if [[  -z $databaseExistCheck ]]
        then
            for folder in ${DBs_path}/*
            do
                unset databases[$l]
                ((l=$l+1))
            done
        fi
        i=0
        for folder in ${DBs_path}/*
        do
            if [[ ! -z $databaseExistCheck ]]
            then
                databases[$i]=$folder # get all databases in an array
            fi
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
                    databasesArrayLength="${#databases[@]}"
                    for database in ${databases[@]}
                    do
                        ((j=$j+1))
                        echo "${blue}press $j for ${database/$DBs_path} ${reset}" # remove path from db name
                    done
                    if [ $databasesArrayLength -gt 0  ]
                    then
                        echo "Please select a database:"
                        read userInput
                    else
                        echo "${red}there are no databases please create at least one table${reset}"
                        break 2
                    fi
                    if [ ${userInput} -le ${j} -a  ${userInput} -gt 0 ]
                    then
                        (( userInput=$userInput-1))
                        myDatabasePath="${databases[$userInput]}"
                        echo "You Are Using : ${myDatabasePath/$DBs_path}"
                        PS3="${myDatabasePath/$DBs_path}: "
                        while true
                        do
                            select choice2 in  'show tables' 'create table' 'delete table' 'select Table' "${blue}back to main${reset}"
                            do
                                filesExistCheck=$(ls ${myDatabasePath}/)
                                c=0
                                if [[  -z $filesExistCheck ]]
                                then
                                    for file in ${myDatabasePath}/*
                                    do
                                        unset databases[$c]
                                        ((c=$c+1))
                                    done
                                fi
                                x=0
                                for file in ${myDatabasePath}/*
                                do
                                    if [[ ! -z $filesExistCheck ]]
                                    then
                                        tables[$x]=$file # get all tables in an array
                                    fi
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
                                            tablesArrayLength="${#tables[@]}"
                                            if [ $tablesArrayLength -gt 0  ]
                                            then
                                                echo "Please select a table:"
                                                read tableUserInput
                                            else
                                                echo "${red}there are no tables please create at least one table${reset}"
                                                break 2
                                            fi
                                            source checkTbExist.sh ${tableUserInput}
                                            if [ $? -eq 1 ]
                                            then
                                                b=0
                                                for file in ${tables[@]}
                                                do
                                                    ((b=$b+1))
                                                done
                                                ((b=$b-1))
                                                unset tables[$b]
                                                rm -f ${myDatabasePath}/${tableUserInput}
                                                rm -f ${myDatabasePath}/".${tableUserInput}.md"
                                                echo "${green}${tableUserInput} has been deleted succesfully${reset}"
                                                filesExistCheck=$(ls ${myDatabasePath}/)
                                                break
                                            else
                                                echo "${red}this Table is Not Existed${reset}"
                                            fi
                                        done
                                        break
                                    ;;
                                    4) echo "select"
                                        while true
                                        do
                                            tablesArrayLength="${#tables[@]}"
                                            k=0
                                            for table in ${tables[@]}
                                            do
                                                ((k=$k+1))
                                                echo "${blue}press $k for ${table/$myDatabasePath} ${reset}" # remove path from db name
                                            done
                                            if [ $tablesArrayLength -gt 0  ]
                                            then
                                                echo "Please select a table:"
                                                read tableUserInput
                                            else
                                                echo "${red}there are no tables please create at least one table${reset}"
                                                break 2
                                            fi
                                            if [ ${tableUserInput} -le ${k} -a  ${tableUserInput} -gt 0 ]
                                            then
                                                (( tableUserInput=$tableUserInput-1))
                                                arrayTableName="${tables[$tableUserInput]}"
                                                tableName=$(echo "${tables[$tableUserInput]}" | rev | cut -d'/' -f 1 | rev)
                                                echo "You Are Using : ${arrayTableName/$myDatabasePath}"
                                                PS3="${arrayTableName/$myDatabasePath}: "
                                                let rowNum=$(awk -F: 'END{print NR}' ${myDatabasePath}/".${tableName}.md");
                                                awk -v rowNumber="$(($rowNum))" -F: 'BEGIN{OFS = ":"}{if(NR!=1){for(i=0;i<rowNumber ;i++){if($i == ""){$i = "NULL"}}};print $0}' ${myDatabasePath}/$tableName >> ${myDatabasePath}/"${tableName}.new";
                                                mv ${myDatabasePath}/"${tableName}.new" ${myDatabasePath}/$tableName;
                                                while true
                                                do
                                                    select choice2 in  'insert into table' 'update table' 'drop row from table' 'display all' 'add column to table' 'drop column from table' 'print a row' 'print a column' "${blue}back to main${reset}"
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
                                                            7) echo "show record from table"
                                                                source showRecord.sh ${tableName}
                                                                break
                                                            ;;
                                                            8) echo "show record from table"
                                                                source showFeild.sh ${tableName}
                                                                break
                                                            ;;
                                                            9)
                                                                echo "back to main"
                                                                PS3="#? "
                                                                break 3
                                                            ;;
                                                            *) break ;;
                                                        esac
                                                    done
                                                done
                                            else
                                                echo "${red}Invalid table or there are no tables please choose again${reset}"
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
                        echo "${red}Invalid database or there are no databases please choose again${reset}"
                        continue 1
                    fi
                done
            ;;
            3)
                echo -e "\n"
                echo "******** DataBases **********"
                ls --color ${DBs_path}
                echo "*****************************"
                echo -e "\n"
                echo "Enter new dataBase name "
                read databaseName
                while true
                do
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
                echo -e "\n"
                echo "******** DataBases **********"
                ls --color ${DBs_path}
                echo "*****************************"
                echo -e "\n"
                databasesArrayLength="${#databases[@]}"
                if [ $databasesArrayLength -gt 0  ]
                then
                    echo "Enter dataBase name "
                    read databaseName
                else
                    echo "${red}there are no databases please create at least one database${reset}"
                    break
                fi
                a=0
                for folder in ${databases[@]}
                do
                    ((a=$a+1))
                done
                echo $a
                ((a=$a-1))
                unset databases[$a]
                source deleteDb.sh ${databaseName}
                databaseExistCheck=$(ls ${DBs_path}/)
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
