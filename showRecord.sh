#!/usr/bin/bash

function showRecordFromTable {
    source displayAll.sh ${1}
    while true
    do
        echo "${yellow}do you want proceed y or n ${reset}"
        read userInput
        if [ $userInput = "y" ]
        then
            primaryKeyColNumber=$(awk -F: '{if($3 == "1") print NR}' ${myDatabasePath}/".${1}.md");
            primaryKeyColNumber=$(($primaryKeyColNumber - 1))
            echo "${blue}please enter a primary key of the row you want to show ${reset}"
            read primaryKey
            isFounded=$(awk -v colData="$primaryKey" -v pk="$primaryKeyColNumber" -F: 'BEGIN{isFounded=0} {if($pk==colData){isFounded=1}} END{print isFounded}' ${myDatabasePath}/$1)
            if [ $(($isFounded)) -eq 1 ]
            then
                rowNumToBeEdited=$(awk -v i="$primaryKeyColNumber" -v pk="$primaryKey" -F: '{if($i == pk) print NR}' ${myDatabasePath}/$1);
                feildToBeEditedColumnNumber=$(awk -v field="$feildName" -F: '{if($1 == field) print NR}' ${myDatabasePath}/".${1}.md");
                feildToBeEditedColumnNumber=$(($feildToBeEditedColumnNumber - 1))
                sed -n "/$primaryKey/p" ${myDatabasePath}/$1 >> ${myDatabasePath}/".${1}.temp"
                maxlen=$(awk -F: 'BEGIN{maxlen=0} {for(j=1;j<=NF;j++) {if(maxlen < length($j)) {maxlen = length($j)}  } } END{print maxlen+4}' ${myDatabasePath}/".${1}.temp")
                awk -v maxleng=$(($maxlen)) -F: 'BEGIN{}{} END{for(i=0;i<((maxleng*NF)+4);i++){ printf "_"};printf "\n"}' ${myDatabasePath}/".${1}.temp"
                awk -v maxleng=$(($maxlen)) -F: 'BEGIN{}{if(NR!=1){ printf("%s",$1);for(j=0;j<((maxleng-length($1)));j++){printf(" ")};printf("|");  }}END{printf("\n")}' ${myDatabasePath}/.$1.md
                awk -v maxleng=$(($maxlen)) -F: 'BEGIN{}{for(i=0;i<((maxleng*NF)+4);i++){ printf "_"}; print "" ; for(i=1;i<=NF;i++){ printf("%s",$i);for(j=0;j<((maxleng-length($i)));j++){printf(" ")};printf("|")};printf("\n")} END{for(i=0;i<((maxleng*NF)+4);i++){ printf "_"};printf "\n";printf "\n"}' ${myDatabasePath}/".${1}.temp"
                rm -f ${myDatabasePath}/".${1}.temp"
            else
                echo "${red}this primary key doesn't exist${reset}"
            fi
        else
            break
        fi
    done
}
showRecordFromTable $1