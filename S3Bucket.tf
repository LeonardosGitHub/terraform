/*
{
    "Properties": {
        "AccessControl": "BucketOwnerFullControl"
    },
    "Type": "AWS::S3::Bucket",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "id": "cdf07568-4732-4b2a-b048-3473b1aab927"
        }
    }
}
##  2019-06-21 I Believe this matches the CFT configuration, perhaps naming will need to be adjusted##
*/


resource "aws_s3_bucket" "S3Bucket" {
  bucket = lower("waf-${var.fqdn_app_name}-${var.deploymentName}-bucket")
  acl    = "private"

  tags = {
    Name = "waf-${var.fqdn_app_name}-${var.deploymentName}"
  }
}
