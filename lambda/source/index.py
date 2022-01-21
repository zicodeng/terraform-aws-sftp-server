import os
import json
import boto3
import base64
from botocore.exceptions import ClientError


def lambda_handler(event, context):
    print("Event: "+json.dumps(event))

    if 'username' not in event or 'password' not in event or 'serverId' not in event:
        print("Field username, password, or serverId missing in event")
        return {}

    # Validate username
    inputUsername = event['username']
    secretUsername = retrieve_secret('username')
    if secretUsername == None:
        print("Error retrieving username secret")
        return {}
    if inputUsername != secretUsername:
        print('Username incorrect')
        return {}

    # Validate password.
    inputPassword = event['password']
    secretPassword = retrieve_secret('password')
    if secretPassword == None:
        print("Error retrieving password secret")
        return {}
    if inputPassword != secretPassword:
        print('Password incorrect')
        return {}

    # Construct response data.
    res = {
        'Role': os.environ['Role'],
        'HomeDirectory': os.environ['HomeDirectory']
    }

    print("Response Data: "+json.dumps(res))
    return res


def retrieve_secret(name):
    """
    Retrieve secret from Secrets Manager.
    """

    region = os.environ['SecretsManagerRegion']
    prefix = os.environ['SecretIdPrefix']
    secretId = prefix + '/' + name

    print("Secrets Manager region: "+region)
    print('Retrieving secret from Secrets Manager for ' + secretId)

    client = boto3.session.Session().client(
        service_name='secretsmanager', region_name=region)

    try:
        secret = client.get_secret_value(SecretId=secretId)
        print("Secret: " + secret['SecretString'])
        return secret['SecretString']

    except ClientError as err:
        print('Error connecting to Secrets Manager: ' + str(err))
        return None
