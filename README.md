## Goals
Needs curating and trimming. Just a mind-dump.
 * Approachable. Minimize the upfront investment and tooling. Have good
   documentation. Explain why.
 * Extensible. Provide the basics as well as patterns for expansion based on
   unique business needs
 * Best Practices "For Free". Always apply best practices for security,
   monitoring, and scaling.
 * Minimize managed resources. Minimize operation costs. Maximized work "not" done.
 * Be smart about vendor specific dependencies.
 * Battery included monitoring.
 * Feedback wanted. This should be a community effort. The quality of this stack
   should ratcheted up through the specialties of community members.

## Principles
Needs curating and trimming. Just a mind-dump.
 * Everything is disposable. This places focus on being cheap and repeatable to
   create and encourages healthy development practices for applications that can
   be deployed at scale.
 * Encourage environmental isolation.
 * Minimize static infrastructure requirements.
 * Provide opinions and patterns that users can run with.
 * Stay off the web console. If you need to visit the web console, you (I) have
   failed.

## Background
The opinions and choices reflected by this recipe are informed through over 4
years of operation within a startup setting. I wanted to encode the choices and
opinions I have developed over this time frame in to an off-the-shelf product
hat is approachable for anyone wanting to deploy a technology product.

## Current Problems

### Module Dependencies
There are currently a good number of modules. Perhaps too many. The principle
challenge with this many modules is managing their dependencies, and likewise
the order in which they must be instantiated. For instance, it is not
immediately obvious that global/users must be created before global/groups, nor
that global/topics must be created before global/alarms. The number of modules
is also a bit annoying at create time.

### Configuration
A number of important values are currently hard-coded. Especially region and
state buckets. I am not certain how I want to go about addressing this at the
moment, except to add a global configuration file. This will run in to problems
with configurations wishing to diversify among multiple regions.

## Terraform
https://github.com/awslabs/apn-blog
https://github.com/hashicorp/best-practices
http://www.antonbabenko.com/2016/09/21/how-i-structure-terraform-configurations.html


https://github.com/gruntwork-io/terragrunt

https://github.com/unifio/terraform-aws-iam
https://github.com/unifio/terraform-aws-asg
https://github.com/unifio/terraform-aws-vpc


## Scaling Terraform
https://www.youtube.com/watch?v=RldRDryLiXs
https://github.com/segmentio/stack
https://segment.com/blog/the-segment-aws-stack/

split state, use read-only
use remote state


## Bootstrap
 * Root account API access (automatically deleted after bootstrap)
 * Root account MFA. Save a copy of the QR code or the secret key in a secure place
 * Activate IAM Access to Billing Information
 * Enable "Receive Billing Alerts" under preferences

## Audit
 * CloudTrail is enabled for all regions to provide a record of API actions

## Notifications
 * Billing alarms. Don't get surprised.
 * Root account usage (?)

## Refactoring Terraform
https://www.youtube.com/watch?v=OH6iDKaXpZs


## IAM Policies
https://awspolicygen.s3.amazonaws.com/policygen.html
http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_variables.html
http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html


## IAM Groups
 * Developers
 * System Administrators
 * Power Users (no IAM, KMS, deny state buckets and other specific resources)
 * Administrators

## Issues
 * Configurable state bucket
 * Configurable region
 * Migrating existing account?
 * Encrypting remote state. How to set kms_key_id

## EBS Snapshot Scheduler
http://docs.aws.amazon.com/solutions/latest/ebs-snapshot-scheduler/welcome.html


## Testing
http://kitchen.ci/

/*
*  S3 Buckets Storage
*/




/*
*  1) CloudTrail IAM, KMS
*/

/*
*  1) Policies
*  2) Users, Access Keys
*  3) Groups
*  4) Roles
*  5) Instance Profiles
*/

/*
*  1) ECR aws_ecr_repository
*/

/*
*  1) DNS
*/

/*
*  1) VPC aws_vpc
*  2) Internet Gateway aws_internet_gateway
*  3) Routing Tables aws_route_table, aws_route, aws_route_table_association
*  4) Subnets aws_subnet
*  5) Security Groups aws_security_group, aws_security_group_rule
*/

/*
*  1) RDS Instance
*/

/*
*  1) SNS
*  2) CloudWatch
*/
