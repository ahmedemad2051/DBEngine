#!/usr/bin/bash

function deleteColFromTable {
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
            if [ $(($isFounded)) -eq 0 ]
            then
                awk -F: -v j=$(($feildToBeEditedColumnNumber - 1)) 'BEGIN{OFS = ":"}{$j = "";ORS=" ";print $0;}' ${myDatabasePath}/$1 >> ${myDatabasePath}/"${1}.new";
                mv ${myDatabasePath}/"${1}.new" ${myDatabasePath}/$1;
                # sed -i "s/[^:]*|//$(($feildToBeEditedColumnNumber - 1))" ${myDatabasePath}/$1;
                sed -i "/$feildName/d" ${myDatabasePath}/".${1}.md";
            else
                echo "${red}you cannot delete the primary key${reset}"
            fi
        else
            break
        fi
    done
}
deleteColFromTable $1