import boto3
from dotenv import load_dotenv
from botocore.exceptions import NoCredentialsError

load_dotenv(verbose=True)

def upload_to_aws(filepath, appname, env, bucket, s3_file):
    filename = '/{}/{}-{}-{}'.format(appname, env, appname, version)
    s3 = boto3.client('s3', aws_access_key_id=ACCESS_KEY,
                      aws_secret_access_key=SECRET_KEY)

    try:
        s3.upload_file(filepath, bucket, filename)
        print("{}/{} Upload Successful".format(filepath, filename))
        return True
    except FileNotFoundError:
        print("{} was not found".format(filename))
        return False
    except NoCredentialsError:
        print("Credentials not available")
        return False