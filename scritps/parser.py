from os.path import join
import os
import sys
import asyncio
import json
from base64 import b64encode, b64decode
from urllib import request
from urllib.parse import urlencode
from urllib.error import HTTPError
import pdb

pwd = os.getcwd()
file_names = ["envfile", "terraform.tfvars", "test_file.json"]

def parse_envfile_to_json():
    envfile = open(file_names[0].format(pwd, file_names[0]), 'r')

    result = {
        "terraform": {},
        "docker": {},
        "aws": {}
    }

    lines = envfile.read().splitlines()
    try:
        for line in lines:
            key = line.split('=')[0]
            value = line.split('=')[1]

            if line.startswith('terraform_'):
                if value.strip().startswith("[") and value.strip().endswith("]"):
                    result["terraform"][key.split('terraform_')[1].strip()] = value.strip().strip('][').split(', ')
                else:
                    result["terraform"][key.split('terraform_')[1].strip()] = value.strip()
            elif line.startswith('docker_'):
                result["docker"][key.split('docker_')[1].strip()] = value.strip()
            elif line.startswith('aws_'):
                result["aws"][key.split('aws_')[1].strip()] = value.strip()
            else:
                pass
    except Exception as e:
        print("애러가 발생했습니다.", e)
    envfile.close()

    return result

def create_terraform_envs(app_name, env, result, verb='set'):
    terraform_json = result['terraform']
    terraform_kv_data =[]

    try:
        for key, value in terraform_json.items():
            terraform_kv_data.append(
                {
                    'Key': '{}/env/{}/terraform/{}'.format(app_name, env, key),
                    'Value': b64encode(str(value).encode('utf-8')).decode('utf-8')
                }
            )
    except TypeError as e:
        print("DataType이 잘못 되었습니다.", e)
    except Exception as e:
        print("terraform_envs 애러가 발생 하였습니다.", e)
    return terraform_kv_data

def create_docker_envs(app_name, env, result, verb='set'):
    docker_json = result['docker']
    docker_kv_data =[]

    try:
        for key, value in docker_json.items():
            if key.startswith("app_"):
                split_key = key.split("app_")[1]
                key = '{}/env/{}/docker/{}/{}'.format(app_name, env, "app", split_key)
            elif key.startswith("ad_"):
                split_key = key.split("ad_")[1]
                key = '{}/env/{}/docker/{}/{}'.format(app_name, env, "ad", split_key)

            docker_kv_data.append(
                {
                    'Key': key,
                    'Value': b64encode(str(value).encode('utf-8')).decode('utf-8')
                }
            )
    except TypeError as e:
        print("DataType이 잘못 되었습니다.", e)
    except Exception as e:
        print("docker_env 애러가 발생 하였습니다.", e)
    return docker_kv_data


def create_aws_tags(app_name, env, result, verb='set'):
    aws_json = result['aws']
    aws_kv_data =[]

    try:
        for key, value in aws_json.items():
            aws_kv_data.append(
                {
                    'Key': '{}/env/{}/aws/{}'.format(app_name, env, key),
                    'Value': b64encode(str(value).encode('utf-8')).decode('utf-8')
                }
            )
    except TypeError as e:
        print("DataType이 잘못 되었습니다.", e)
    except Exception as e:
        print("aws_tag 애러가 발생 하였습니다.", e)
    return aws_kv_data