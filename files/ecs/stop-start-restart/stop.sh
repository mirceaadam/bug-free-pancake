#!/bin/bash

ECS_CLUSTER_NAME="YOUR-Test"
#SERVICES:
# YOURCron YOURBackend YOURNotification YOURFrontend YOURExport YOURUser
AWS_REGION="eu-north-1"
AWS_PROFILE="test-migration"

for service_name in `cat ./services`
do
echo -e "-----------------------------------------"
echo -e "----> Set to kill: $service_name <-------"
echo -e "-----------------------------------------"
aws ecs update-service \
    --cluster $ECS_CLUSTER_NAME \
    --service $service_name \
    --region $AWS_REGION \
    --profile $AWS_PROFILE \
    --desired-count 0
#   --force-new-deployment
done