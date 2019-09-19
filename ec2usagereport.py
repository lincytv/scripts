import boto3
import sys
from datetime import datetime, timedelta
import csv
region = 'ap-south-1'
start_time = datetime(2019, 9, 19)
end_time = datetime(2019, 9, 19)
conn = boto3.client('cloudwatch', 'ap-south-1')
conn2 = boto3.client("ec2", region)
responce = conn2.describe_instances()
for i in responce['Reservations']:
    instance_id = i['Instances'][0]['InstanceId']
    instance_state = i['Instances'][0]['State']['Name']
    instance_type = i['Instances'][0]['InstanceType']
    instance_launchtime =  i['Instances'][0]['LaunchTime']
    instance_running = datetime.date(datetime.now()) - datetime.date(instance_launchtime)
    for a in i['Instances'][0]['Tags']:
        if a['Key'] == "Name":
            instance_name = a['Value']
        if a['Key'] == "Function":
            instance_function =  a['Value']
        if a['Key'] == "Environment":
            instance_env =  a['Value']
    response = conn.get_metric_statistics(
        Namespace='AWS/EC2',
        MetricName='CPUUtilization',
        Dimensions=[
            {
            'Name': 'InstanceId',
            'Value': instance_id
            },
        ],
        StartTime=start_time - timedelta(seconds=600),
        EndTime=end_time,
        Period=86400,
        Statistics=[
            'Average',
        ],
        Unit='Percent'
    )
    # print(response)
    for cpu in response['Datapoints']:
        if 'Average' in cpu:
            linein = [ [instance_name, instance_function, instance_env, instance_id, instance_type, instance_state, datetime.time(instance_launchtime), instance_running ,cpu['Average']] ]
            with open('people.csv', 'a') as writeFile:
                writer = csv.writer(writeFile)
                writer.writerows(linein)
writeFile.close()                
