## Security
This module is a work in progress.

I am well aware that the password is in clear text for this module. At the
moment this database instance is never left running. More over, it is not
publicly exposed.

Before finishing work on this module, a method for securely setting and storing
the root user password should be found.

## SSH Forwarding
This database is setup within the private subnets of the VPC. You can reach it
using SSH forwarding via the bastion instance.
```
ssh -i id_rsa -N -L 5432:ci-database.cbl4l1zwnvtl.us-east-1.rds.amazonaws.com:5432 user@bastion
```
