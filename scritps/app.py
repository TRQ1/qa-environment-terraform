import os
import sys
from dotenv import load_dotenv
from parser import parse_envfile_to_json
from parser import create_docker_envs
from parser import create_aws_tags
from parser import create_terraform_envs
from config_file import create_tfvars
from consul import put_kv_data
from consul import get_kv


if __name__ == '__main__':
    env = sys.argv[1]
    app_name = sys.argv[2]
    version = sys.argv[3]
    result = parse_envfile_to_json() # json 형태

    tfvars = create_tfvars(result) # result 값으로 바로 전달
    terraform_envs = create_terraform_envs(app_name, env, result) # result 값으로 바로 전달
    docker_envs = create_docker_envs(app_name, env, result) # result 값으로 바로 전달
    aws_tags = create_aws_tags(app_name, env, result) # result 값으로 바로 전달

    get_kv(docker_envs, aws_tags)
    put_kv_data(terraform_envs, docker_envs, aws_tags)