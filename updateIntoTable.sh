#!/usr/bin/bash
stringReg="^[a-zA-Z ]+[a-zA-Z ]*$"
intReg="^[0-9]+[0-9]*$|^(NULL)|^(null)"
alphNumReg="^[a-zA-Z_ ]+[a-zA-Z ]+[0-9a-zA-Z_ ]*$"

function checkPrimaryKeyRepeted {
    if [ $(($2)) -eq 1 ]
    then
        if [ $3 = "NULL" -o $3 = "null" ]
        then
            return 1
        else
            isFounded=$(awk -v i="$4" -v colData="$3" -F: 'BEGIN{isFounded=0} {if($i==colData){isFounded=1}} END{print isFounded}' ${myDatabasePath}/$1)
            if [ $(($isFounded)) -eq 1 -a $(($2)) -eq 1 ]
            then
                return 1
            else
                return 0
            fi
        fi
    fi
}
function updateIntoTable {
    while true
    do
        source displayAll.sh ${1}
        echo "${yellow}do you want proceed y or n ${reset}"
        read userInput
        if [ $userInput = "y" ]
        then
            primaryKeyColNumber=$(awk -F: '{if($3 == "1") print NR}' ${myDatabasePath}/".${1}.md");
            primaryKeyColNumber=$(($primaryKeyColNumber - 1))
            echo "${blue}please enter a primary key of the row you want to edit ${reset}"
            read primaryKey
            isFounded=$(awk -v colData="$primaryKey" -v pk="$primaryKeyColNumber" -F: 'BEGIN{isFounded=0} {if($pk==colData){isFounded=1}} END{print isFounded}' ${myDatabasePath}/$1)
            if [ $(($isFounded)) -eq 1 ]
            then
                while true
                do
                    echo "${blue}please enter the name of feild you want to edit ${reset}"
                    read feildName
                    isFounded=$(awk -v Data="$feildName" -F: 'BEGIN{isFounded=0} {if($1==Data){isFounded=1}} END{print isFounded}' ${myDatabasePath}/".${1}.md")
                    if [ $(($isFounded)) -eq 1 ]
                    then
                        break
                    else
                        echo "${red}The Feild you Entered does not match any table's feilds, Please Try Again ${reset}"
                    fi
                done
                rowNumToBeEdited=$(awk -v i="$primaryKeyColNumber" -v pk="$primaryKey" -F: '{if($i == pk) print NR}' ${myDatabasePath}/$1);
                feildToBeEditedColumnNumber=$(awk -v field="$feildName" -F: '{if($1 == field) print NR}' ${myDatabasePath}/".${1}.md");
                feildToBeEditedColumnNumber=$(($feildToBeEditedColumnNumber - 1))
                colPrimary=$(awk -v i="$(($feildToBeEditedColumnNumber))" -F: '{if(NR == (i + 1)) print $3}' ${myDatabasePath}/".${1}.md");
                colType=$(awk -v i="$(($feildToBeEditedColumnNumber))" -F: '{if(NR == (i + 1)) print $2}' ${myDatabasePath}/".${1}.md");
                case $colType in
                    Int)
                        while true
                        do
                            echo "${blue}please enter the new value ${reset}"
                            read newValue
                            checkPrimaryKeyRepeted $1 $colPrimary $newValue $feildToBeEditedColumnNumber
                            if [ $? -eq 1 ]
                            then
                                echo "${red} Primary Key Cannot be Reppeted or null ${reset}"
                            else
                                if [[ $newValue =~ $intReg ]]
                                then
                                    break 1
                                else
                                    echo "${red}Invalid type,please try again.${reset}"
                                fi
                            fi
                        done
                        
                    ;;
                    String)
                        while true
                        do
                            echo "${blue}please enter the new value ${reset}"
                            read newValue
                            checkPrimaryKeyRepeted $1 $colPrimary $newValue $feildToBeEditedColumnNumber
                            if [ $? -eq 1 ]
                            then
                                echo "${red} Primary Key Cannot be Reppeted or null ${reset}"
                            else
                                if [[ $newValue =~ $stringReg ]]
                                then
                                    break 1
                                else
                                    echo "${red}Invalid type,please try again.${reset}"
                                fi
                            fi
                        done
                        
                    ;;
                    AlphaNumeric)
                        while true
                        do
                            echo "${blue}please enter the new value ${reset}"
                            read newValue
                            checkPrimaryKeyRepeted $1 $colPrimary $newValue $feildToBeEditedColumnNumber
                            if [ $? -eq 1 ]
                            then
                                echo "${red} Primary Key Cannot be Reppeted or null ${reset}"
                            else
                                if [[ $newValue =~ $alphNumReg ]]
                                then
                                    break 1
                                else
                                    echo "${red}Invalid type,please try again.${reset}"
                                fi
                            fi
                        done
                    ;;
                esac
                awk -v rowNumber="$rowNumToBeEdited" -v colNumber="$feildToBeEditedColumnNumber" -v newData="$newValue" -F: 'BEGIN{OFS = ":"}{if(NR == rowNumber){$colNumber = newData};print $0;}' ${myDatabasePath}/$1 >> ${myDatabasePath}/"${1}.new";
                mv ${myDatabasePath}/"${1}.new" ${myDatabasePath}/$1;
                source displayAll.sh ${1}
            else
                echo "${red}this primary key doesn't exist${reset}"
            fi
        else
            break
        fi
    done
}
updateIntoTable $1