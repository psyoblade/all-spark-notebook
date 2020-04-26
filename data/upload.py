import boto3
data = open('users.parquet', 'rb')
s3 = boto3.resource('s3')
s3.Bucket('psyoblade-fluentd').put_object(Key='parquet/users.parquet', Body=data)
