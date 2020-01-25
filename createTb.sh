#!/usr/bin/bash


function addTableColumns {
    while true
    do
        echo "Enter number of columns"
        read columnsNumber
        if [ $((columnsNumber)) -gt 0  -a $((columnsNumber)) -le 100  ]
        then
            counter=0
            while (($columnsNumber>0))
            do
                # column name
                while true
                do
                    ((counter=counter+1))
                    echo "Enter Column ${counter} name"
                    read columnName
                    source checkSyntax.sh ${columnName}
	                colValid=$?
	                if [ $colValid -eq 1 ]
	                then
	                    # check column existed before
                        isFounded=$(awk -v colName="$columnName" -F: 'BEGIN{isFounded=0} {if($1==colName){isFounded=1}} END{print isFounded}' ${myDatabasePath}/".${1}.md")
                        if [ $isFounded -eq 1 ]
                        then
                             echo "${red}Column Already Exists, please try another name ${reset}"
                        else
                            break   # break loop if column name is valid and not exist before
                        fi
	                else
	                     echo "${red}Syntax not valid. column name must start with letters or _${reset}"
	                fi
                done

                # column type
                while true
                do
                    echo "Choose Column type"
                    select columnType in "Int" "String" "AlphaNumeric"
                    do
                        case $REPLY in
                        [123])
                            break 2
                        ;;
                        *)
                            echo "${red}Invalid type,please try again.${reset}"
                            break
                        ;;
                        esac
                    done
                done

                # primary or not
                while true
                do
                    echo "Enter 1 if column is primary key and 0 if it's not"
                    read primaryKey
                    if [[ ${primaryKey} == "0"  || ${primaryKey} == "1" ]]
                    then
                        if [[ ${primaryKey} == "1"  ]]
                        then
                           # check table has primary key before
                            hasPrimary=$(awk -F: 'BEGIN{isFounded=0} {if($3==1){isFounded=1}} END{print isFounded}' ${myDatabasePath}/".${1}.md")
                            if [ $hasPrimary -eq 1 ]
                            then
                                 echo "${red}Table Already has a primary key ${reset}"
                            else
                                break
                            fi
                        else
                            break
                        fi
                    else
                        echo "${red} Sorry,you must choose 0 or 1 only.${reset}"
                    fi
                done
                sed -i "$ a $columnName:$columnType:$primaryKey" ${myDatabasePath}/".${1}.md"
                ((columnsNumber=$columnsNumber-1))
            done
            break # leave columns add function after finish
        else
            echo "${red} Sorry,valid number of columns between 1 and 100.${reset}"
        fi
    done
}

if [ $# -gt 0 ]
then
    source checkSyntax.sh
	syntaxValid=$?
	# table syntax valid
	if [ $syntaxValid -eq 1 ]
	then
        source checkTbExist.sh
        isExisted=$?
        if [ $isExisted -eq 1 ]
        then
            echo "${red}table already Exists please try another name${reset}"
            continue 1
        else
            touch ${myDatabasePath}/$1
            echo "~~Data of table $1~~" > ${myDatabasePath}/$1
            touch ${myDatabasePath}/".${1}.md"
            echo "~~metaData of table $1~~" > ${myDatabasePath}/".${1}.md"
            echo "${green}Table created successfully${reset}"
            addTableColumns $1
            break 1
        fi
    else
        echo "${red}Syntax not valid. table name must start with letters or _${reset}"
    fi
fi






