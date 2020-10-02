#! /bin/sh

echo 'exec docker-compose default sample'
docker-compose run app
echo '----------------------------------'

echo 'exec docker-compose override sample'
docker-compose -f docker-compose.yml -f docker_compose_commands/docker-compose-command-sample.yml run app
echo '----------------------------------'
