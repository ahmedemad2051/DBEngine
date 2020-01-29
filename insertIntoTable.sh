#!/usr/bin/bash
stringReg="^[a-zA-Z]+[a-zA-Z]*$"
intReg="^[0-9]+[0-9]*$"
alphNumReg="^[a-zA-Z_]+[a-zA-Z]+[0-9a-zA-Z_]*$"
let counter=2
flag=false
function insertIntoDataBase {
    while true
    do
        let colNum=$(awk -v i="$counter" -F: 'END{print NR}' ${myDatabasePath}/".${1}.md");
        if [ $colNum -eq $counter ]
        then 
            flag=true
        fi
        colName=$(awk -v i="$counter" -F: '{if(NR == i) print $1}' ${myDatabasePath}/".${1}.md");
        echo Please Enter $colName Data
        read colData
        colType=$(awk -v i="$counter" -F: '{if(NR == i) print $2}' ${myDatabasePath}/".${1}.md");
        let colPrimary=$(awk -v i="$counter" -F: '{if(NR == i) print $3}' ${myDatabasePath}/".${1}.md");
        while true
        do
            isFounded=$(awk -v i="$counter" -v colName="$colData" -F: 'BEGIN{isFounded=0} {if($i==colData){isFounded=1}}' ${myDatabasePath}/$1)
            if [ $isFounded -eq 1 && colPrimary -eq 1 ]
            then
                echo "${red} Primary Key Cannot be Reppeted ${reset}"
            else
                break
        done
        case $colType in
            Int)
                while true
                do
                    read colData
                    if [[ $colData =~ $intReg ]]
                    then
                        break;
                    else
                        echo "${red}Invalid type,please try again.${reset}"
                        break 
                    fi
                done
                break
            ;;
            String)
                while true
                do
                    read colData
                    if [[ $colData =~ $stringReg ]]
                    then
                        break 
                    else
                        echo "${red}Invalid type,please try again.${reset}"
                    fi
                done
                break
            ;;
            AlphaNumeric)
                while true
                do
                    read colData
                    if [[ $colData =~ $alphNumReg ]]
                    then
                        break;
                    else
                        echo "${red}Invalid type,please try again.${reset}"
                    fi
                done
                break
            ;;
        esac
        if [ $flag == "false" ]
        then
            sed -i "$ s/$/${colData}:/" ${myDatabasePath}/$1
        else {
            sed -i "$ s/$/${colData}\n/" ${myDatabasePath}/$1
            break
        }
        fi
        echo $flag
        ((counter=$counter+1))
    done
}
insertIntoDataBase $1
