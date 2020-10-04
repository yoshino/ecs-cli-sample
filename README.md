# README
## The case: You want to pass arguments to ECS task
```
$ ./bin/exec_ecs_cli.sh comp1 comp2 comp3
```

## vs docker-compose
In docker-compose, you can override file,

```
$ docker-compose -f docker-compose.yml -f docker_compose_commands/docker-compose-command-sample.yml run app
```

But ecs-cli does not have this syntax.

So, if you want to override commands, you may use ENV.

## Setup
### 1: setup your aws profile

edit `terraform/variables.tf`

### 2: setup aws resources

```
$ cd terraform
$ terraform apply
```

### 3: setup ECR

```
$ docker build -t ecs-cli-task .
$ ecs-cli push --aws-profile <YOUR_PROFILE> --verbose ecs-cli-test
```
