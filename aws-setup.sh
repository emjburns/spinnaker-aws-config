#!/bin/bash

# Define your names
export AWS_ACCOUNT_NAME=my_aws_account
export AWS_VPC_NAME=my_vpc_name
export AWS_SUBNET_NAME=my_subnet_name

export MANAGING_ACCOUNT_ID=123-your-master-account-id
export MANAGED_ACCOUNT_ID=123-your-master-account-id

# Setup pulled from https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-subnets-commands-example.html

# Create and name VPC
AWS_VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 | jq --raw-output '.Vpc.VpcId')
aws ec2 create-tags --resource $AWS_VPC_ID --tags Key=name,Value=$AWS_VPC_NAME

# Create and name single subnet
AWS_SUBNET_ID=$(aws ec2 create-subnet --vpc-id $AWS_VPC_ID --cidr-block 10.0.0.0/24 | jq --raw-output '.Subnet.SubnetId')
aws ec2 create-tags --resource $AWS_SUBNET_ID --tags Key=name,Value=$AWS_SUBNET_NAME

# Create and attach Internet Gateway 
AWS_INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway | jq --raw-output '.InternetGateway.InternetGatewayId')
aws ec2 attach-internet-gateway --vpc-id $AWS_VPC_ID --internet-gateway-id $AWS_INTERNET_GATEWAY_ID

# Create Route Table
AWS_ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $AWS_VPC_ID | jq --raw-output '.RouteTable.RouteTableId')

aws ec2 create-route --route-table-id $AWS_ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $AWS_INTERNET_GATEWAY_ID

# Confirm route table is active
aws ec2 describe-route-tables --route-table-id $AWS_ROUTE_TABLE_ID
AWS_RT_ASSOCIATION_ID=$(aws ec2 associate-route-table --subnet-id $AWS_SUBNET_ID --route-table-id $AWS_ROUTE_TABLE_ID | jq --raw-output '.AssociationIds')


# Create ec2 user
# TODO

# Create Keypair
export AWS_KEYPAIR_NAME=${AWS_ACCOUNT_NAME}-keypair
aws ec2 create-key-pair --key-name $AWS_KEYPAIR_NAME | jq --raw-output '.KeyMaterial' > ${AWS_KEYPAIR_NAME}.pem
chmod 400 ${AWS_KEYPAIR_NAME}.pem


# Roles/Policies/Permissions managed/managing account
# TODO