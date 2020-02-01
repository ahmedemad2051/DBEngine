#!/usr/bin/bash

maxlen=$(awk -F: 'BEGIN{maxlen=0} {if(NR!=1) {for(j=1;j<=NF;j++) {if(maxlen<length($j)) {maxlen=length($j)} } } } END{print maxlen}' ${myDatabasePath}/$1)
maxlen=$(($maxlen+3))
awk -v maxlen=$(($maxlen)) -F: 'BEGIN{}{} END{for(i=0;i<((((maxlen)-length($i)))*NF);i++){ printf "_"};printf "\n"}' ${myDatabasePath}/$1
awk -v maxlen=$(($maxlen)) -F:  'BEGIN{}{if(NR!=1){ printf("%s",$1);for(j=0;j<((maxlen-length($1)));j++){printf(" ")};printf("|");  }}END{printf("\n")}' ${myDatabasePath}/.$1.md
awk -v maxlen=$(($maxlen)) -F: 'BEGIN{}{if(NR!=1){ for(i=0;i<((((maxlen)-length($i)))*NF);i++){ printf "_"}; print "" ; for(i=1;i<=NF;i++){ printf("%s",$i);for(j=0;j<((maxlen-length($i)));j++){printf(" ")};printf("|")};printf("\n")}} END{for(i=0;i<((((maxlen)-length($i)))*NF);i++){ printf "_"};printf "\n";printf "\n"}' ${myDatabasePath}/$1
