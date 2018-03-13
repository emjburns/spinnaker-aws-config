# spinnaker-aws-config
Scripted setup to get your aws account ready for Spinnaker

Work in progress to replace https://www.spinnaker.io/setup/install/providers/aws/

## Prep Work
- Make sure that the `aws` cli is installed and configured on the machine you're running, and that the env var `AWS_DEFAULT_REGION` is set.

If you're running this from an EC2 instance make sure that the instance profile attached to that instance has the permissions:
```
	ec2:*
	iam:*
	sts:passRole
	sts:AssumeRole
```

Then run:
```bash
	sudo apt-get install awscli
	AWS_DEFAULT_REGION=us-west-2 # Or your default region
```

- Provide account details in `fill-me-out.json`
Feel free to change the default names or leave them. They will show up in the UI as identifiers for the account/vpc/subnet.
MANAGING_ACCOUNT_ID is the account ID that Spinnaker is running in.
MANAGED_ACCOUNT_IDS is an array of account IDs of accounts that Spinnaker is managing.
AUTH_TYPE is the [method of authentication](https://www.spinnaker.io/setup/install/providers/aws/#configure-an-authentication-mechanism).
	If Spinnaker is running inside of EC2, chose "role".
	If Spinnaker is running outside of EC2, chose "user". This will need to be created through the console following [these steps](https://www.spinnaker.io/setup/install/providers/aws/#option-2-add-a-user-and-access-key--secret-pair).

- Spinnaker needs to be able to assume roles in all accounts it manages (this includes the account it's running in). Edit spinnaker-assume-role-policy.json to replace:
`${ACCOUNT_ID}` with the account ID that Spinnaker is running in
If your Spinnaker will connect to more than one account, add a new `Resource` to the `Resource` block for every account that Spinnaker will manage:
`"arn:aws:iam::${MANAGED_ACCOUNT_ID}:role/spinnakerManaged",`

