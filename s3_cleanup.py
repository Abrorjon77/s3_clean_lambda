import boto3
import os

def lambda_handler(event, context):
    bucket_name = os.environ['BUCKET_NAME']
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(abrorjon-python-test-bucket)
    
    for obj in bucket.objects.all():
        obj.delete()

import boto3
import datetime

# Set the name of the S3 bucket
BUCKET_NAME = 'my-s3-bucket'

# Set the threshold for alerting the DevOps team in hours
ALERT_THRESHOLD_HOURS = 24

# Create a client object for interacting with S3
s3 = boto3.client('s3')

# Get the date/time when the bucket was last emptied
bucket_lifecycle = s3.get_bucket_lifecycle_configuration(Bucket=BUCKET_NAME)
last_empty_date = bucket_lifecycle['Rules'][0]['Expiration']['Date']

# Get the current date/time
current_date = datetime.datetime.utcnow()

# Calculate the time elapsed since the bucket was last emptied
time_elapsed = current_date - last_empty_date
# Check if any files exist in the S3 bucket
bucket_contents = s3.list_objects_v2(Bucket=BUCKET_NAME)
if 'Contents' in bucket_contents:
    print("Lingering files detected in S3 bucket!")
    print(bucket_contents)

# Check if the time elapsed since the bucket was last emptied exceeds the alert threshold
if time_elapsed.total_seconds() > (ALERT_THRESHOLD_HOURS * 3600):
    print("Alert: S3 bucket has not been emptied in over", ALERT_THRESHOLD_HOURS, "hours!")
    # Send an alert to the DevOps team here (e.g. using SNS or another notification service)        
