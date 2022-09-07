#!/usr/bin/env bash

# Quick and dirty deployment script

export AWS_ACCOUNT=<account_id>
export AWS_REGION=us-east-1
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com

export CONTAINERS="\
db_init
web_app_php
web_app_django"

while read CNAME; do
  if ! aws ecr describe-repositories  --region us-east-1 --repository-names ${CNAME} > /dev/null 2>&1; then
    echo "Creating new ECR (${CNAME})"
    aws ecr create-repository --repository-name ${CNAME} --region ${AWS_REGION}
  fi
  docker build -t ${CNAME}:latest ${CNAME}; docker tag ${CNAME}:latest ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${CNAME}:latest; docker push ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${CNAME}:latest
done <<< "${CONTAINERS}"
