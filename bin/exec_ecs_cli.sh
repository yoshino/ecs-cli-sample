#! /bin/sh

PROFILE=yoshino
ACCOUNT=`aws --profile ${PROFILE} sts get-caller-identity | jq -r .Account | tr -d "\n"`
AWS_DEFAULT_REGION=ap-northeast-1
DOCKER_REGISTRY=$ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/

ECS_CLUSTER=test-ecs-cli-cluster
SUBNET=`aws --profile ${PROFILE} ec2 describe-subnets --filters Name=tag:Name,Values=test-ecs-cli-subnet | jq '.Subnets[].SubnetId'`
SECURITY_GROUP=`aws --profile ${PROFILE} ec2 describe-security-groups --filters Name=tag:Name,Values=test-ecs-cli  | jq '.SecurityGroups[].GroupId'`

HOGE=$1 FOO=$2 BAR=$3 \
DOCKER_REGISTRY=$DOCKER_REGISTRY SUBNET=$SUBNET SECURITY_GROUP=$SECURITY_GROUP \
ecs-cli compose --aws-profile $PROFILE \
                --project-name test-ecs-cli \
                --file ./ecs/ecs-compose.yml \
                --ecs-params ./ecs/ecs-params.yml \
                --cluster $ECS_CLUSTER up \
                --launch-type FARGATE
