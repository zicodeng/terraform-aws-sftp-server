import os
import json
import boto3
import base64
from botocore.exceptions import ClientError


def lambda_handler(event, context):
    print("Event: "+json.dumps(event))

    if 'username' not in event or 'serverId' not in event:
        print("Field username or serverId missing in event")
        return {}

    inputUsername = event['username']
    inputPassword = event['password']

    secret = retrieve_secret(inputUsername)
    if secret == None:
        print("Error retrieving secret")
        return {}

    # Validate password.
    if inputPassword == '':
        print('Password missing in event')
        return {}
    if 'Password' not in secret:
        print('Password missing in secret')
        return {}
    if inputPassword != secret['Password']:
        print('Password incorrect')
        return {}

    # Construct response data.
    res = {}

    # This field is required, so we need to default to empty string if not set.
    if 'Role' in secret:
        res['Role'] = secret['Role']
    else:
        res['Role'] = ''

    # These are optional so ignore if not present.
    if 'Policy' in secret:
        res['Policy'] = secret['Policy']

    if 'HomeDirectoryDetails' in secret:
        print("HomeDirectoryDetails found in secret. Applying setting for virtual folders")
        res['HomeDirectoryDetails'] = secret['HomeDirectoryDetails']
        res['HomeDirectoryType'] = "LOGICAL"
    elif 'HomeDirectory' in secret:
        print("HomeDirectory found in secret")
        res['HomeDirectory'] = secret['HomeDirectory']
    else:
        print("HomeDirectory not found in secret. Default to /")

    print("Response Data: "+json.dumps(res))
    return res


def retrieve_secret(username):
    """
    Retrieve secret from Secrets Manager for a given user.
    """

    prefix = 'SFTP/'
    secretId = prefix + username

    region = os.environ['SecretsManagerRegion']
    print('Retrieving secret from Secrets Manager for ' + secretId)
    print("Secrets Manager region: "+region)

    client = boto3.session.Session().client(
        service_name='secretsmanager', region_name=region)

    try:
        secret = client.get_secret_value(SecretId=secretId)

        # Decrypts secret using the associated KMS CMK.
        # Depending on whether the secret is a string or binary, one of these fields will be populated.
        print("Secret: " + secret['SecretString'])
        if 'SecretString' in secret:
            print("Found secret string")
            return json.loads(secret['SecretString'])
        else:
            print("Found binary secret")
            return json.loads(base64.b64decode(secret['SecretBinary']))

    except ClientError as err:
        print('Error connecting to Secrets Manager: ' + str(err))
        return None
