/*
############################################
## Simple Notification Service            ##
## 'email' is not supported by terraform" ##
############################################

"Properties": {
    "Subscription": [
        {
            "Endpoint": {
                "Ref": "notificationEmail"
            },
            "Protocol": "email"
        }
    ]
},
"Type": "AWS::SNS::Topic",
"Metadata": {
    "AWS::CloudFormation::Designer": {
        "id": "71fbfd3c-2c8c-4013-bec9-037db009c44c"
    }
}


resource "aws_sns_topic_subscription" "SNSTopic" {
  protocol  = "email"
  topic_arn = "arn:aws:sns:us-east-1:"
  endpoint  = var.notificationEmail
}
*/
