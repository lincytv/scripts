import boto3
import tarfile
import os

# variable 
s3bucket = "lincytest"
dirname = "s3upload"
tarfilename = "sample.tar.gz"
filename = []
master_bucket = "lincyfinal"

f = open('s3uploadedlist.log', 'a+')

# functions 

def extract(dirname, tarfilename):
    # dirname = dirname
    # tarfilename = tarfilename
    tf = tarfile.open(tarfilename, "r")
    tf.extractall(path=dirname)

def upload_file(master_bucket,filename):
    print filename
    try:
        conn.put_object(master_bucket, filename)
        f.write(filename)
    except Exception as e:
        print e
        pass
    


conn = boto3.client('s3')

oblist = conn.list_objects_v2(Bucket= s3bucket)
for i in oblist["Contents"]:
    m = i["Key"]
    if m.endswith('.gz'):
        conn.download_file(s3bucket,i["Key"],i["Key"])
        try:
            extract(dirname,i["Key"])
        except Exception as e:
            print e
            pass
fileextrace = os.listdir("s3upload")
os.chdir("s3upload")
for i in fileextrace:
    try:
        conn.put_object(master_bucket, i)
        f.write(i)
    except Exception as e:
        print e
        pass
    #print i
    #upload_file(master_bucket, i )
    #print fileextrace


f.close()


        









