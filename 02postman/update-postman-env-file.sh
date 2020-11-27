#!/usr/bin/env bash

#This shell script updates Postman environment file with the API Gateway URL created
# via the api gateway deployment

echo "Running update-postman-env-file.sh"

api_gateway_url=`aws cloudformation describe-stacks \
  --stack-name api-stack-anni \
  --query "Stacks[0].Outputs[*].{OutputValueValue:OutputValue}" --output text`

echo "API Gateway URL:" ${api_gateway_url}

jq -e --arg apigwurl "$api_gateway_url" '(.values[] | select(.key=="apigw-root") | .value) = $apigwurl' \
  APIEnvironment.postman_environment.json > APIEnvironment.postman_environment.json.tmp \
  && cp APIEnvironment.postman_environment.json.tmp APIEnvironment.postman_environment.json \
  && rm APIEnvironment.postman_environment.json.tmp

echo "Updated APIEnvironment.postman_environment.json"

cat APIEnvironment.postman_environment.json
