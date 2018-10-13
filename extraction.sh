#!/bin/bash
set -e
filename='photo.tar.gz'
sbucket='lincytest'
dbucket='lincyfinal'
mkdir -m 777 s3upload
listfile=$(aws s3api list-objects --bucket $sbucket | jq -r .Contents[].Key)
for i in "${listfile[@]}";
do
   echo "Statted Download $filename - $(date)" | tee -a  /home/lincytv/$filename.log
   xout=$(aws s3api get-object --bucket $sbucket --key $filename $filename)
   tar -xvf $filename -C s3upload
   cd s3upload
   files=$(ls)
     for j in "${files[@]}";
     do
       echo "Statted $j Uploades $(date)" | tee -a  /home/lincytv/$filename.log
       a=$(aws s3api put-object --bucket $dbucket --prefix hires --key $j)
        if [ -z $a ]; then
            echo $j $(date) | tee -a /home/lincytv/$filename-"uploadsucess.log"
        fi
     done
    echo "Statted $j removing" | tee -a  /home/lincytv/$filename.log
    rm -rf ../s3upload $filename
    echo "$j compleated" | tee -a  /home/lincytv/$filename.log
    mail -s "Extraction to S3 completed for the sequence: $filename" -A /home/lincytv/$filename-"uploadsucess.log" -A  /home/lincytv/$filename.log lincyv@alamy.com
done
