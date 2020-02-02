#!/usr/bin/bash

function displayColFromTable {
    source displayAll.sh ${1}
    while true
    do
        echo "${yellow}do you want proceed y or n ${reset}"
        read userInput
        if [ $userInput = "y" ]
        then
            while true
            do
                echo "${blue}please enter the name of feild you want to drop ${reset}"
                read feildName
                isFounded=$(awk -v Data="$feildName" -F: 'BEGIN{isFounded=0} {if($1==Data){isFounded=1}} END{print isFounded}' ${myDatabasePath}/".${1}.md")
                if [ $(($isFounded)) -eq 1 ]
                then
                    break
                else
                    echo "${red}The Feild you Entered does not match any table's feilds, Please Try Again ${reset}"
                fi
            done
            feildToBeEditedColumnNumber=$(awk -v field="$feildName" -F: '{if($1 == field) print NR}' ${myDatabasePath}/".${1}.md");
            isFounded=$(awk -v rowNum="$feildToBeEditedColumnNumber"  -F: 'BEGIN{isFounded=0} {if(NR == rowNum && $3 == 1){isFounded=1}} END{print isFounded}' ${myDatabasePath}/".${1}.md")
            
            awk  -F: -v j=$(($feildToBeEditedColumnNumber - 1)) '{if(NR != 1)print $j}' ${myDatabasePath}/$1 >> ${myDatabasePath}/".${1}.temp"; #print the column from data table
            awk  -F: -v j=$(($feildToBeEditedColumnNumber)) '{if(NR == j)print $1}' ${myDatabasePath}/".${1}.md" >> ${myDatabasePath}/".${1}.new"; #print the column from data table

            maxlen=$(awk -F: 'BEGIN{maxlen=0} {printf "\n\n"; for(j=1;j<=NF;j++) {if(maxlen < length($j)) {maxlen = length($j)}  } } END{print maxlen+4}' ${myDatabasePath}/".${1}.temp")
            awk -v maxleng=$(($maxlen)) -F: 'BEGIN{}{} END{for(i=0;i<((maxleng*NF)+4);i++){ printf "_"};printf "\n"}' ${myDatabasePath}/".${1}.temp"
            awk -v maxleng=$(($maxlen)) -F: 'BEGIN{}{printf("%s",$1);for(j=0;j<((maxleng-length($1)));j++){printf(" ")};printf("|");  }END{printf("\n")}' ${myDatabasePath}/".$1.new"
            awk -v maxleng=$(($maxlen)) -F: 'BEGIN{}{for(i=0;i<((maxleng*NF)+4);i++){ printf "_"}; print "" ; for(i=1;i<=NF;i++){ printf("%s",$i);for(j=0;j<((maxleng-length($i)));j++){printf(" ")};printf("|")};printf("\n")} END{for(i=0;i<((maxleng*NF)+4);i++){ printf "_"};printf "\n";printf "\n"}' ${myDatabasePath}/".${1}.temp"

            rm -f ${myDatabasePath}/".${1}.temp"
            rm -f ${myDatabasePath}/".$1.new"
        else
            break
        fi
    done
}
displayColFromTable $1