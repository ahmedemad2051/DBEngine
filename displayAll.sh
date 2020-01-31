#!/usr/bin/bash

awk -F: 'BEGIN{}{if(NR!=1){ printf("%s",$1);for(j=0;j<((7-length($1)));j++){printf(" ")};printf("|");  }}END{printf("\n")}' ${myDatabasePath}/.$1.md
awk -F: 'BEGIN{}{if(NR!=1){ for(i=0;i<NF;i++){ printf "________"}; print "" ; for(i=1;i<=NF;i++){ printf("%s",$i);for(j=0;j<((7-length($i)));j++){printf(" ")};printf("|")};printf("\n")  }}' ${myDatabasePath}/$1
