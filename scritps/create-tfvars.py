from os.path import join
import os
import sys
import asyncio
import json
from logging import getLogger
from base64 import b64encode, b64decode
from urllib import request
from urllib.parse import urlencode
import pdb

endpoint = ""
pwd = os.getcwd()
file_names = ["envfile", "consule-env", "terrafrom.tfvars", "test"]
log = getLogger(__name__)


def create_envfiles(file_names, pwd):
    file_env = open(file_names[0].format(pwd, file_names[0]), 'r')
    file_consul = open(file_names[1].format(pwd, file_names[1]), 'w')
    file_tfvars = open(file_names[2].format(pwd, file_names[2]), 'w')

    lines = file_env.read().splitlines()
    for line in lines:
          key = line.split('=')[0]
          value = line.split('=')[1]
          file_consul.write('{0}={1}\n'.format(key, value))
          file_tfvars.write('{0} = "{1}"\n'.format(key, value))

    file_env.close()
    file_consul.close()
    file_tfvars.close()

def mapping_to_kv_data(file_names, pwd, verb='set'):
    file_consul = open(file_names[1].format(pwd, file_names[1]), 'r')
    lines = file_consul.read().splitlines()
    kv_data =[]

    for line in lines:
          key = line.split('=')[0]
          value = line.split('=')[1]
          kv_data.append(
              {
                  'KV': {
                      'Verb': verb,
                      'Key': key,
                      'Value': b64encode(str(value).encode('utf-8')).decode('utf-8'),
                  }
              }
          )
    return kv_data

def put_kv(endpoint, file_names, pwd):
    file_consul = open(file_names[1].format(pwd, file_names[1]), 'w')
    lines = file_consul.read().splitlines()
    for line in lines:
        key = line.split('=')[0]
        value = line.split('=')[1] 
        encoded = str.encode(str(value))
        params = dict()
        url = join(endpoint, key) if key else endpoint

        if params:
            url = "{}/?{}".format(url, urlencode(params))


def put_kv_data(file_names, pwd, endpoint, verb='set'):
    kv_data = mapping_to_kv_data(file_names, pwd)

    for kv in kv_data:
        data = json.dumps(kv).encode('utf-8')

        req = request.Request(
            url=endpoint, data=data, method='PUT',
            headers={'Content-Type': 'application/json'}
        )
        with request.urlopen(req) as f:
            log.debug("PUT k v mapping {} to {}: {}".format(
                endpoint, f.status, f.reason
            ))

put_kv_data(file_names, pwd, endpoint)

    










