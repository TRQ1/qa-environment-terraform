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

def create_tfvars(result):
    terraform_json = result['terraform']
    file_tfvars = open(file_names[1].format(pwd, file_names[1]), 'w')

    try:
        for key, value in terraform_json.items():
            tfvars_key = key
            tfvars_value = value
            if isinstance(tfvars_value, str):
                file_tfvars.write('{0} = "{1}"\n'.format(tfvars_key, tfvars_value))
            else:
                file_tfvars.write('{0} = {1}\n'.format(tfvars_key, tfvars_value).replace("\'", "\""))
    except FileNotFoundError:
        print("{} 파일을 찾을 수 없습니다.".format(file_tfvars))
    except Exception as e:
        print("tfvars 에러가 발생 하였습니다.", e)

    file_tfvars.close()



