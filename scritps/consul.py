import json
import os
import sys
from dotenv import load_dotenv
from logging import getLogger
from base64 import b64encode, b64decode
from urllib import request
from urllib.parse import urlencode
from urllib.error import HTTPError

load_dotenv(verbose=True)
endpoint = os.getenv("CONSUL_ENV_URL")
log = getLogger(__name__)

def get_kv(docker_envs, aws_tags):
    kv_data = docker_envs + aws_tags

    try:
        for data in kv_data:
            key = data['KV']['Key']
            print("key: {}".format(key))
            url = "{0}/v1/kv/{1}".format(endpoint, key)
            print(url)

            req = request.Request(
                url=url, method='GET'
            )
            with request.urlopen(req) as r:
                print("This key already exist!!!!")
    except HTTPError as e:
        if e.code == 404:
            pass
        else:
            print(e)
    except Exception as e:
        print(e)

def put_kv_data(terraform_envs, docker_envs, aws_tags, verb='set'):
    kv_data = terraform_envs + docker_envs + aws_tags

    try:
        for kv in kv_data:
            data = b64decode(json.dumps(kv["Value"]))

            req = request.Request(
                url="{}{}".format(endpoint, kv["Key"]), data=data, method='PUT',
                headers={'Content-Type': 'application/json'}
            )
            with request.urlopen(req) as f:
                log.debug("PUT k v mapping {} to {}: {}".format(
                    endpoint, f.status, f.reason
                ))
    except Exception as e:
        print("애러가 발생했습니다.", e)

def put_tfstate_data(endpoint, tfstate_data, verb='set'):
    kv_data = tfstate_data
    try:
        for kv in kv_data:
            data = json.dumps(kv).encode('utf-8')
            print(kv)
            print(kv_data)
            print(endpoint)
            req = request.Request(
                url=endpoint, data=data, method='PUT',
                headers={'Content-Type': 'application/json'}
            )
            with request.urlopen(req) as f:
                log.debug("PUT k v mapping {} to {}: {}".format(
                    endpoint, f.status, f.reason
                ))
    except Exception as e:
        print("애러가 발생했습니다.", e)