#!/bin/bash
filename='#####.csv'
foldername=$(basename $filename .csv)
IFS=,
 while read -r c1 c2 c3
 do

  if [ -f $c2 ]; then
   sudo cp $c2 "$foldername/$c1.${c2##*.}
   echo "${c3}" &>> $foldername"_success.log"
  else
   sudo echo "${c3}" &>> $foldername"_failed.log"
  fi;
 done < $filename
