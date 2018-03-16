#!/bin/bash

validate(){
	print_function_details
	if [ ! -e aws_arns.json ] 
	then
		print_error_and_exit "File aws_arns.json does not exist. No resources to clean up."
	fi 
}

delete_vpc_and_subnet(){
	print_function_details
	# Clean up VPC and Subnet
	aws ec2 delete-subnet --subnet-id $(jq -r '.AWS_SUBNET_ID' aws_arns.json)
	aws ec2 delete-route-table --route-table-id $(jq -r '.AWS_ROUTE_TABLE_ID' aws_arns.json)
	aws ec2 detach-internet-gateway --internet-gateway-id $(jq -r '.AWS_INTERNET_GATEWAY_ID' aws_arns.json) --vpc-id $(jq -r '.AWS_VPC_ID' aws_arns.json)
	aws ec2 delete-internet-gateway --internet-gateway-id $(jq -r '.AWS_INTERNET_GATEWAY_ID' aws_arns.json)
	aws ec2 delete-vpc --vpc-id $(jq -r '.AWS_VPC_ID' aws_arns.json)

	# Clean up Keypair
	aws ec2 delete-key-pair --key-name $(jq -r '.AWS_KEYPAIR_NAME' aws_arns.json)
}

delete_policies_and_roles(){
	print_function_details
	# Clean up Policies
	aws iam delete-policy --policy-name SpinnakerAssumeRolePolicy	
	aws iam delete-policy --policy-name SpinnakerPassRole

	# Clean up Roles 
	aws iam delete-role --role-name BaseIAMRole
	aws iam delete-role --role-name SpinnakerAuthRole
	aws iam delete-role --role-name spinnakerManaged
}

print_function_details(){
		echo "Script step: " ${FUNCNAME[1]}	
}

print_error_and_exit(){
	ERROR_MSG=$1
	echo "Error: " $ERROR_MSG
	exit 1
}

validate
delete_vpc_and_subnet
delete_policies_and_roles