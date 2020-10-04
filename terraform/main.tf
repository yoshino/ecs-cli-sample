# ECS Cluster
# https://www.terraform.io/docs/providers/aws/r/ecs_cluster.html
resource "aws_ecs_cluster" "test-ecs-cli-cluster" {
	name = "test-ecs-cli-cluster"
}

resource "aws_cloudwatch_log_group" "test" {
  name = "test"
}

# IAM
resource "aws_iam_role" "ecs-task-execution-role" {
	name = "ecs-task-execution-role"
	assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ecs-tasks.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  name       = "ecs-task-execution-role-policy-attachment"
  roles      = [aws_iam_role.ecs-task-execution-role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-ssm-read-policy-attachment" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

# VPC
# https://www.terraform.io/docs/providers/aws/r/vpc.html
resource "aws_vpc" "test-ecs-cli-vpc" {
	cidr_block = "10.0.0.0/16"

	tags = {
		Name = "test-ecs-cli-vpc"
	}
}

# SecurityGroup
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "test-ecs-cli-sg" {
	name        = "test-ecs-cli-sg"
	description = "for test ecs cli"

	vpc_id      = aws_vpc.test-ecs-cli-vpc.id

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags = {
		Name = "test-ecs-cli"
	}
}

# Public Subnet
# https://www.terraform.io/docs/providers/aws/r/subnet.html
resource "aws_subnet" "test-ecs-cli-subnet" {
	vpc_id = aws_vpc.test-ecs-cli-vpc.id

	availability_zone = "ap-northeast-1a"

	cidr_block = "10.0.1.0/24"

	tags = {
		Name = "test-ecs-cli-subnet"
	}
}

# Internet Gateway
# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
resource "aws_internet_gateway" "test-ecs-cli-igw" {
	vpc_id = aws_vpc.test-ecs-cli-vpc.id

	tags = {
		Name = "test-ecs-cli-igw"
	}
}

# Elasti IP
# https://www.terraform.io/docs/providers/aws/r/eip.html
resource "aws_eip" "test-ecs-cli-eip" {
	vpc = true

	tags = {
		Name = "test-ecs-cli-eip"
	}
}

# NAT Gateway
# https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
resource "aws_nat_gateway" "test-ecs-cli-natgw" {
	subnet_id     = aws_subnet.test-ecs-cli-subnet.id
	allocation_id = aws_eip.test-ecs-cli-eip.id

	tags = {
		Name = "test-ecs-cli-natgw"
	}
}

# Route Table
# https://www.terraform.io/docs/providers/aws/r/route_table.html
resource "aws_route_table" "public-route-table" {
	vpc_id = aws_vpc.test-ecs-cli-vpc.id

	tags = {
		Name = "public-route-table"
	}
}

# Route
# https://www.terraform.io/docs/providers/aws/r/route.html
resource "aws_route" "public-route" {
	destination_cidr_block = "0.0.0.0/0"
	route_table_id         = aws_route_table.public-route-table.id
	gateway_id             = aws_internet_gateway.test-ecs-cli-igw.id
}

# Association
# https://www.terraform.io/docs/providers/aws/r/route_table_association.html
resource "aws_route_table_association" "public-table-test-ecs-cli-subnet-association" {
	route_table_id = aws_route_table.public-route-table.id
	subnet_id      = aws_subnet.test-ecs-cli-subnet.id
}
