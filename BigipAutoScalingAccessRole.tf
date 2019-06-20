{
            "Properties": {
                "AssumeRolePolicyDocument": {
                    "Statement": [
                        {
                            "Action": [
                                "sts:AssumeRole"
                            ],
                            "Effect": "Allow",
                            "Principal": {
                                "Service": [
                                    "ec2.amazonaws.com"
                                ]
                            }
                        }
                    ],
                    "Version": "2012-10-17"
                },
                "Path": "/",
                "Policies": [
                    {
                        "PolicyDocument": {
                            "Statement": [
                                {
                                    "Action": [
                                        "s3:ListBucket"
                                    ],
                                    "Effect": "Allow",
                                    "Resource": {
                                        "Fn::Join": [
                                            "",
                                            [
                                                "arn:*:s3:::",
                                                {
                                                    "Ref": "S3Bucket"
                                                }
                                            ]
                                        ]
                                    }
                                },
                                {
                                    "Action": [
                                        "s3:PutObject",
                                        "s3:GetObject",
                                        "s3:DeleteObject"
                                    ],
                                    "Effect": "Allow",
                                    "Resource": {
                                        "Fn::Join": [
                                            "",
                                            [
                                                "arn:*:s3:::",
                                                {
                                                    "Ref": "S3Bucket"
                                                },
                                                "/*"
                                            ]
                                        ]
                                    }
                                },
                                {
                                    "Action": [
                                        "sqs:SendMessage",
                                        "sqs:ReceiveMessage",
                                        "sqs:DeleteMessage"
                                    ],
                                    "Effect": "Allow",
                                    "Resource": {
                                        "Fn::GetAtt": [
                                            "SQSQueue",
                                            "Arn"
                                        ]
                                    }
                                },
                                {
                                    "Action": [
                                        "autoscaling:DescribeAutoScalingGroups",
                                        "autoscaling:DescribeAutoScalingInstances",
                                        "autoscaling:SetInstanceProtection",
                                        "ec2:DescribeInstances",
                                        "ec2:DescribeInstanceStatus",
                                        "ec2:DescribeAddresses",
                                        "ec2:AssociateAddress",
                                        "ec2:DisassociateAddress",
                                        "ec2:DescribeNetworkInterfaces",
                                        "ec2:DescribeNetworkInterfaceAttribute",
                                        "ec2:DescribeRouteTables",
                                        "ec2:ReplaceRoute",
                                        "ec2:assignprivateipaddresses",
                                        "ec2:DescribeTags",
                                        "ec2:CreateTags",
                                        "ec2:DeleteTags",
                                        "sts:AssumeRole",
                                        "cloudwatch:PutMetricData"
                                    ],
                                    "Effect": "Allow",
                                    "Resource": [
                                        "*"
                                    ]
                                },
                                {
                                    "Action": [
                                        "s3:GetObject"
                                    ],
                                    "Effect": "Allow",
                                    "Resource": {
                                        "Ref": "bigIqPasswordS3Arn"
                                    }
                                }
                            ],
                            "Version": "2012-10-17"
                        },
                        "PolicyName": "BigipAutoScalingAcccessPolicy"
                    }
                ]
            },
            "Type": "AWS::IAM::Role",
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "3639d19c-65fd-4cd3-9ad1-bc74f341e751"
                }
            }
        }
