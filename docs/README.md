## Tools
Most of these tools are python based, and as such, are much nicer when installed
with virtualenv.

### virtualenvwrapper
Python virtualenv management tool
Site: https://virtualenvwrapper.readthedocs.io/en/latest/
This should be the only tool that is required to be installed at the system
level.
Install:
```
sudo apt-get update && sudo apt-get install virtualenvwrapper
```

### AWS CLI
Universal Command Line Interface for Amazon Web Services
Site: https://github.com/aws/aws-cli
Install:
```
pip install aws-cli
```

### AWS Shell (Optional)
The interactive productivity booster for the AWS CLI
Site: https://github.com/awslabs/aws-shell
Install:
```
pip install aws-shell
```

## AWS CLI MFA Setup
```
[profile admin]
role_arn = arn:aws:iam::<account>:role/<role>
source_profile = default
region = us-east-1
mfa_serial = arn:aws:iam::<account>:mfa/<user>
```

It can be used as in the following example:
```
awsudo -u admin terraform plan
```
