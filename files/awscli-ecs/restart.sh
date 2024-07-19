#!/bin/bash

AWS_PROFILE=$1
ECS_SERVICE_NAME=$2
ECS_CLUSTER_NAME="YOUR-Test"
AWS_REGION="eu-north-1"

aws ecs update-service \
    --cluster $ECS_CLUSTER_NAME \
    --service $ECS_SERVICE_NAME \
    --region $AWS_REGION \
    --profile $AWS_PROFILE \
    --force-new-deployment