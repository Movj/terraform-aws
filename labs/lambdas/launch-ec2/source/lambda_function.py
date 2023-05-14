import json
import boto3
import time
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Provision and launch the EC2 instance
    ec2_client = boto3.client('ec2')
    try:
        response = ec2_client.run_instances(ImageId='ami-0b69ea66ff7391e80',
                                            InstanceType='t2.micro',
                                            MinCount=1,
                                            MaxCount=1)
        # Get the instance id
        instance_id = response['Instances'][0]['InstanceId']

        # Tag the resource
        ec2_tag = ec2_client.create_tags(Resources=[instance_id], Tags=[{'Key':'Name', 'Value':'Test_Lambda_Function'}])                                    

        print(response['Instances'][0], "EC2 Instance Created")
        return {
            'statusCode': 200,
            'body': json.dumps("success")
        }

    except ClientError as e:
        print("Detailed error: ", e)
        return {
            'statusCode': 500,
            'body': json.dumps("error")
        }

    except Exception as e:
        print("Detailed error: ", e)
        return {
            'statusCode': 500,
            'body': json.dumps("error")
        }