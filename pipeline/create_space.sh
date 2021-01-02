#!/bin/bash
LOCAL_PATH=$(pwd)
T_WORKSPACE=$(cd ${LOCAL_PATH}/env/${INFRA_ENV}/ && terraform workspace list | grep ${APP_NAME} | awk '{ print $1 }')

if [[ ${T_WORKSPACE} != ${APP_NAME} ]]; then
      export AWS_PROFILE=${AWS_ENV} && cd ${LOCAL_PATH}/env/${INFRA_ENV}/ && terraform workspace new ${APP_NAME} && terraform plan -out=./terraform_plan -var aws_profile=${AWS_ENV}
else
      export AWS_PROFILE=${AWS_ENV} && cd ${LOCAL_PATH}/env/${INFRA_ENV}/ && terraform workspace select ${APP_NAME} && terraform plan -out=./terraform_plan -var aws_profile=${AWS_ENV}
fi
