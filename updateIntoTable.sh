function updateIntoTable {
    while true
    do
        primaryKeyRowNumber=$(awk -F: '{if($3 == "1") print NR}' ${myDatabasePath}/".${1}.md");
        primaryKeyRowNumber=$(($primaryKeyRowNumber - 1))
        echo $primaryKeyRowNumber
        echo "${blue}please enter a primary key of the row you want to edit ${reset}"
        read primaryKey
        rowNumToBeEdited=$(awk -v i="$primaryKeyRowNumber" -v pk="$primaryKey" -F: '{if($i == pk) print NR}' ${myDatabasePath}/$1);
        echo "${blue}please enter the name of feild you want to edit ${reset}"
        read feildName
        feildToBeEditedColumnNumber=$(awk -v field="$feildName" -F: '{if($1 == field) print NR}' ${myDatabasePath}/".${1}.md");
        feildToBeEditedColumnNumber=$(($feildToBeEditedColumnNumber - 1))
        echo $feildToBeEditedColumnNumber
        echo "${blue}please enter the new value ${reset}"
        read newValue
        awk -v rowNumber="$rowNumToBeEdited" -v colNumber="$feildToBeEditedColumnNumber" -v newData="$newValue" -F: 'BEGIN{OFS = ":"}{if(NR == rowNumber){$colNumber = newData};print $0;}' ${myDatabasePath}/$1 >> ${myDatabasePath}/"${1}.new";
        echo koko
        mv ${myDatabasePath}/"${1}.new" ${myDatabasePath}/$1;
        echo after mv  
    done
}
updateIntoTable $1