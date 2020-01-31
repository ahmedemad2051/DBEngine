#!/usr/bin/bash
stringReg="^[a-zA-Z ]+[a-zA-Z ]*$"
intReg="^[0-9]+[0-9]*$|^(NULL)|^(null)"
alphNumReg="^[a-zA-Z_ ]+[a-zA-Z ]+[0-9a-zA-Z_ ]*$"
let counter=2
flag=false
function checkPrimaryKeyRepeted {
    if [ $(($2)) -eq 1 ]
    then
        if [ $3 = "NULL" -o $3 = "null" ]
        then
            return 1
        else
            isFounded=$(awk -v i="$(($counter - 1))" -v colData="$3" -F: 'BEGIN{isFounded=0} {if($i==colData){isFounded=1}} END{print isFounded}' ${myDatabasePath}/$1)
            if [ $(($isFounded)) -eq 1 -a $(($2)) -eq 1 ]
            then
                return 1
            else
                return 0
            fi
        fi
    fi
}
function insertIntoTable {
    while true
    do
        let rowNum=$(awk -F: 'END{print NR}' ${myDatabasePath}/".${1}.md");
        dataRowNum=$(awk -F: 'END{print NR}' ${myDatabasePath}/$1);
        let colPrimary=$(awk -v i="$counter" -F: '{if(NR == i) print $3}' ${myDatabasePath}/".${1}.md");
        if [ $(($dataRowNum)) -eq 1 -o $(($counter)) -eq 2 ]
        then
            sed -i "$ s/$/\n/" ${myDatabasePath}/$1
        fi
        if [ $(($colPrimary)) -eq 1 -a $(($dataRowNum)) -gt 1 ]
        then
            if [ $(($counter)) -eq 2 ]
            then
                declare lastPrimaryKey=$(awk -v i="$(($counter - 1))" -v rowNum="$(($dataRowNum))" -F: 'BEGIN {lastprimary=0} {if(NR == rowNum)lastprimary=$i} END{print lastprimary}' ${myDatabasePath}/$1);
                echo $lastPrimaryKey
                echo "${blue}the last Primary Key was $lastPrimaryKey${reset}"
            else
                declare lastPrimaryKey=$(awk -v i="$(($counter - 1))" -v rowNum="$(($dataRowNum))" -F: 'BEGIN {lastprimary=0} {if(NR == rowNum - 1)lastprimary=$i} END{print lastprimary}' ${myDatabasePath}/$1);
                echo $lastPrimaryKey
                echo "${blue}the last Primary Key was $lastPrimaryKey${reset}"
            fi
        elif [ $(($colPrimary)) -eq 1 -a $(($dataRowNum)) -eq 1 ]
        then
            echo "${blue}Enter a your fitst primary key data${reset}"
        fi
        if [ $rowNum -eq $counter ]
        then
            flag=true
        fi
        colName=$(awk -v i="$counter" -F: '{if(NR == i) print $1}' ${myDatabasePath}/".${1}.md");
        colType=$(awk -v i="$counter" -F: '{if(NR == i) print $2}' ${myDatabasePath}/".${1}.md");
        case $colType in
            Int)
                while true
                do
                    echo Please Enter $colName Data
                    read colData
                    checkPrimaryKeyRepeted $1 $colPrimary $colData
                    if [ $? -eq 1 ]
                    then
                        echo "${red} Primary Key Cannot be Reppeted or null ${reset}"
                    else
                        if [[ $colData =~ $intReg ]]
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
                    echo Please Enter $colName Data
                    read colData
                    checkPrimaryKeyRepeted $1 $colPrimary $colData
                    if [ $? -eq 1 ]
                    then
                        echo "${red} Primary Key Cannot be Reppeted or null ${reset}"
                    else
                        if [[ $colData =~ $stringReg ]]
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
                    echo Please Enter $colName Data
                    read colData
                    checkPrimaryKeyRepeted $1 $colPrimary $colData
                    if [ $? -eq 1 ]
                    then
                        echo "${red} Primary Key Cannot be Reppeted or null ${reset}"
                    else
                        if [[ $colData =~ $alphNumReg ]]
                        then
                            break 1
                        else
                            echo "${red}Invalid type,please try again.${reset}"
                        fi
                    fi
                done
            ;;
        esac
        if [ $flag == "false" ]
        then
            sed -i "$ s/$/${colData}:/" ${myDatabasePath}/$1
        else {
                sed -i "$ s/$/${colData}/" ${myDatabasePath}/$1
                break
            }
        fi
        ((counter=$counter+1))
    done
}
insertIntoTable $1