https://github.com/unifio/terraform-aws-iam

account URL

MFA on root account
https://safenet.gemalto.com/partners/aws/idprove-otp-hardware-tokens/

enable password policy

terraform output secret | base64 -d | gpg --decrypt

/*
{
    "Effect": "Allow",
    "Action": [
        "iam:*AccessKey*",
        "iam:*Password",
        "iam:*MFADevice*",
        "iam:UpdateLoginProfile"
    ],
    "Resource": "arn:aws:iam::*:user/${aws:username}"
},
{
    "Effect": "Allow",
    "Action": [
        "iam:CreateVirtualMFADevice",
        "iam:DeleteVirtualMFADevice"
    ],
    "Resource": "arn:aws:iam::*:mfa/${aws:username}"
},

*/

/*

  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": [
                  "iam:ListAccessKeys",
                  "iam:GetAccessKeyLastUsed",
                  "iam:DeleteAccessKey",
                  "iam:CreateAccessKey",
                  "iam:UpdateAccessKey"
              ],
              "Effect": "Allow",
              "Resource": [
                  "arn:aws:iam::AWS_ACCOUNT_ID:user/${aws:username}"
              ]
          }
      ]
  }
*/

MFA in general

"Condition": {
  "Bool": { "aws:MultiFactorAuthPresent": false }
  "NumericLessThan": {"aws:MultiFactorAuthAge": "3600"}
}


cloudtrail + all regions + s3 bucket is very restricted access

consider tag based access control


job-function groups:
  * iam
  * developer
  * dba



/*
*  Instance Profile
*  1) arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly
*  2) arn:aws:iam::aws:policy/CloudWatchFullAccess
*/
