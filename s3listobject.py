import boto3
import botocore
from boto3.s3.transfer import S3Transfer
f = open('filelist.log', 'a+')
#date_start = "2017-10-06"
#date_end = "2017-10-07"
s3bucketname = "########"
#print "starting date: ",date_start
#print "ending date: ",date_end
print s3bucketname
conn = boto3.client('s3')
paginator = conn.get_paginator('list_objects')

#s3_keys = conn.list_objects(Bucket=s3bucketname, MaxKeys=50000000)['Contents']
operation_parameters = {'Bucket': s3bucketname,'Prefix': '#####'}

for i in paginator.paginate(**operation_parameters)['Contents']: #s3_keys['Contents']:
    f.write(i['Key'])
    print i['Key']
f.close()
