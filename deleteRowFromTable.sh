#!/usr/bin/bash

function deleteRowFromTable {
    while true
    do
        source displayAll.sh ${1}
        echo "${yellow}do you want proceed y or n ${reset}"
        read userInput
        if [ $userInput = "y" ]
        then
            primaryKeyColNumber=$(awk -F: '{if($3 == "1") print NR}' ${myDatabasePath}/".${1}.md");
            primaryKeyColNumber=$(($primaryKeyColNumber - 1))
            echo "${blue}please enter a primary key of the row you want to delete ${reset}"
            read primaryKey
            isFounded=$(awk -v colData="$primaryKey" -v pk="$primaryKeyColNumber" -F: 'BEGIN{isFounded=0} {if($pk==colData){isFounded=1}} END{print isFounded}' ${myDatabasePath}/$1)
            if [ $(($isFounded)) -eq 1 ]
            then
                rowNumToBeEdited=$(awk -v i="$primaryKeyColNumber" -v pk="$primaryKey" -F: '{if($i == pk) print NR}' ${myDatabasePath}/$1);
                feildToBeEditedColumnNumber=$(awk -v field="$feildName" -F: '{if($1 == field) print NR}' ${myDatabasePath}/".${1}.md");
                feildToBeEditedColumnNumber=$(($feildToBeEditedColumnNumber - 1))
                sed -i "/$primaryKey/d" ${myDatabasePath}/$1;
            source displayAll.sh ${1}
            else
                echo "${red}this primary key doesn't exist${reset}"
            fi
        else
            break
        fi
    done
}
deleteRowFromTable $1