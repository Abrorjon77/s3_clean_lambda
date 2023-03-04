import boto3
import os

def lambda_handler(event, context):
    bucket_name = os.environ['BUCKET_NAME']
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(abrorjon-python-test-bucket)
    
    for obj in bucket.objects.all():
        obj.delete()
