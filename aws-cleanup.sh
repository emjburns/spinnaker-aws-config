#!/bin/bash

# Clean up VPC and Subnet
aws ec2 delete-subnet --subnet-id $AWS_SUBNET_ID
aws ec2 delete-route-table --route-table-id $AWS_ROUTE_TABLE_ID
aws ec2 detach-internet-gateway --internet-gateway-id $AWS_INTERNET_GATEWAY_ID --vpc-id $AWS_VPC_ID
aws ec2 delete-internet-gateway --internet-gateway-id $AWS_INTERNET_GATEWAY_ID
aws ec2 delete-vpc --vpc-id $AWS_VPC_ID

# Clean up Keypair
aws ec2 delete-key-pair --key-name $AWS_KEYPAIR_NAME