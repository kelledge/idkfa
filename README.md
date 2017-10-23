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
 * Offer straight forward solution for storing and granting access to sensitive
   credentials like API tokens and database passwords.

## Principles
Needs curating and trimming. Just a mind-dump.
 * Everything is disposable. This places focus on being cheap and repeatable to
   create and encourages healthy development practices for applications that can
   be deployed at scale.
 * Encourage environmental isolation.
 * Minimize static infrastructure requirements.
 * Provide opinions and patterns that users can run with.
 * Stay off the web console. If you need to visit the web console, you (I) have
   failed. The web console can not be scripted. Un-scripted actions can not be
   made repeatable. Un-repeatable actions inexorably lead to chaos.

## Background
The opinions and choices reflected by this recipe are informed through over 4
years of operation within a startup setting. I wanted to encode the choices and
opinions I have developed over this time frame in to an off-the-shelf product
that is approachable for anyone wanting to deploy a technology product.

## Scope
The scope is pretty broad. It may require some pruning, but I do feel that the
following are essentials.

 * Infrastructure Lifecycle
 * IAM (Identity and Access Management)
 * Monitoring and Alerting
 * Service Secret Management

## Current Problems

### Todo
 * Configurable state bucket
 * Configurable region
 * Migrating existing account?
 * Encrypting remote state. How to set kms_key_id
 * Bastion instance profile. Pragmatic balance between minimizing resources and
   dedicating bastion instance to VPC ingress role. I believe it would be nice
   to use the bastion as a NAT instance, as well as for hosting some services
   like the CI build server, or ticket management server. Many of these services
   will likely want access to AWS resources, and therefore require an instance
   profile granting access.

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

## Bootstrap
Bootstrapping should be made as simple as possible and involve as little web
console as possible.

 * Root account API access (should be automatically deleted after bootstrap)
 * Root account MFA. Save a copy of the QR code or the secret key in a secure place
 * Activate IAM Access to Billing Information
 * Enable "Receive Billing Alerts" under preferences

## Audit
 * CloudTrail is enabled for all regions to provide a record of API actions

## Notifications
 * Billing alarms. Don't get surprised
 * Root account usage
 * Unauthorized access attempts
 * Changes to notifications themselves

## IAM Policies
https://awspolicygen.s3.amazonaws.com/policygen.html
http://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_variables.html
http://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html

## IAM Groups
 * Developers
 * Billing
 * System Administrators
 * Power Users (no IAM, KMS, deny state buckets and other specific resources)
 * Administrators

## Ideas

### EBS Snapshot Scheduler
Your data should mostly live in managed services like RDS. Your backup and
recovery configurations should also be defined in these managed services.

That being said, it is often the case that you need to store important data on
EBS attached storage. Important data should be regularly backed up and restore
procedures regularly tested. Unfortunately, EC2 does not have any built-in
functionality for automating EBS snapshot creation. Try to shim this bit of
functionality in with lambda.

Additional advice: always place this data in dedicated EBS volumes and attach
these volumes to the instances that manage their data. Never store important
data (I.E. data you do not want to lose) on instance volumes.

http://docs.aws.amazon.com/solutions/latest/ebs-snapshot-scheduler/welcome.html
https://github.com/gabormay/ebs-backups

### Scripts
 * `passwd` style password management
 * Refresh MFA. I hope this can alleviate the need to logout/login when MFA has
   expired on the web console.
 * MFA device management. Especially create. Add aws-cli configuration profile?
 * Automated tool download. Probably mostly useful for pinning software
   versions.

```
res = create_virtual_mfa_device(**kwargs)
res['VirtualMFADevice']['SerialNumber']
res['VirtualMFADevice']['QRCodePNG']
res['VirtualMFADevice']['Base32StringSeed']

res = enable_mfa_device(
  UserName='string',
  SerialNumber='string',
  AuthenticationCode1='string',
  AuthenticationCode2='string'
)
```
## Testing
There is quite a bit to do here.
http://kitchen.ci/
