/*
##########################
## Simple Queue Service ##
##########################
{
    "Properties": {
        "MessageRetentionPeriod": 3600
    },
    "Type": "AWS::SQS::Queue",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "id": "fabce08b-1b7e-44a4-bee3-ea5e732f9f9b"
        }
	}
}
##  2019-06-21 I Believe this matches the CFT configuration, perhaps naming will need to be adjusted##
*/

resource "aws_sqs_queue" "SQSQueue" {
  #name                      = "waf-${var.fqdn_app_name}-${aws_vpc.terraform-vpc-secexample.id}"
  name = "waf-${var.fqdn_app_name}-${var.deploymentName}"
  #delay_seconds             = 90
  #max_message_size          = 2048
  message_retention_seconds = 3600
  #receive_wait_time_seconds = 10
  #redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.terraform_queue_deadletter.arn}\",\"maxReceiveCount\":4}"
}
