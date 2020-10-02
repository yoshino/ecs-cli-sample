#! /bin/sh

echo 'exec docker-compose default sample'
docker-compose run app
echo '----------------------------------'

echo 'exec docker-compose override sample'
docker-compose -f docker-compose.yml -f docker_compose_commands/docker-compose-command-sample.yml run app
echo '----------------------------------'

# REF: https://docs.docker.com/compose/environment-variables/#the-env-file
echo 'exec docker-compose env sample'
docker-compose -f docker-compose-use-env.yml run app
echo '----------------------------------'

echo 'exec docker-compose override env sample'
HOGE="override_env_hoge" FOO="override_env_foo" BAR="override_env_bar" docker-compose -f docker-compose-use-env.yml run app
echo '----------------------------------'
