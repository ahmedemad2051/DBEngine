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
                    #                    if [ $((columnsNumber)) -eq 1 ]
                    #                    then
                    #                        echo "Notice:first column in the table will be the primary key"
                    #                    fi
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
                    echo "${gray}Notice:if you do not choose a primary key. first column will be the primary key${reset}"
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
            #            check there is a primary key if not make the first column a primary
            hasPrimary=$(awk -F: 'BEGIN{isFounded=0} {if($3==1){isFounded=1}} END{print isFounded}' ${myDatabasePath}/".${1}.md")
            if [ $hasPrimary -eq 0 ]
            then
                awk -F: 'BEGIN{OFS=FS}{if(NR==2){$3=1};print}' ${myDatabasePath}/".${1}.md" > ${myDatabasePath}/".${1}.tmp.md" && mv ${myDatabasePath}/".${1}.tmp.md" ${myDatabasePath}/".${1}.md"
            fi
            
            break # leave columns add function after finish
        else
            echo "${red} Sorry,valid number of columns between 1 and 100.${reset}"
        fi
    done
    let rowNum=$(awk -F: 'END{print NR}' ${myDatabasePath}/".${1}.md");
    awk -v rowNumber="$(($rowNum))" -F: 'BEGIN{OFS = ":"}{if(NR!=1){for(i=0;i<rowNumber ;i++){if($i == ""){$i = "NULL"}}};print $0}' ${myDatabasePath}/$1 >> ${myDatabasePath}/"${1}.new";
    mv ${myDatabasePath}/"${1}.new" ${myDatabasePath}/$1;
    source displayAll.sh ${1}
}

if [ $# -gt 0 ]
then
    source checkTbExist.sh ${1}
    if [ $? -eq 0 ]
    then
        touch ${myDatabasePath}/$1
        echo "~~Data of table $1~~" > ${myDatabasePath}/$1
        touch ${myDatabasePath}/".${1}.md"
        echo "~~metaData of table $1~~" > ${myDatabasePath}/".${1}.md"
        echo "${green}Table created successfully${reset}"
    fi
    source displayAll.sh ${1}
    addTableColumns $1
    break 1
fi