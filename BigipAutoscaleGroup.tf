{
            "Properties": {
                "Cooldown": 1500,
                "DesiredCapacity": {
                    "Ref": "scalingMinSize"
                },
                "HealthCheckGracePeriod": 1500,
                "HealthCheckType": "EC2",
                "LaunchConfigurationName": {
                    "Ref": "BigipLaunchConfig"
                },
                "LoadBalancerNames": [
                    {
                        "Ref": "bigipElasticLoadBalancer"
                    }
                ],
                "MaxSize": {
                    "Ref": "scalingMaxSize"
                },
                "MetricsCollection": [
                    {
                        "Granularity": "1Minute"
                    }
                ],
                "MinSize": {
                    "Ref": "scalingMinSize"
                },
                "NotificationConfigurations": [
                    {
                        "NotificationTypes": [
                            "autoscaling:EC2_INSTANCE_LAUNCH",
                            "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
                            "autoscaling:EC2_INSTANCE_TERMINATE",
                            "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
                        ],
                        "TopicARN": {
                            "Ref": "SNSTopic"
                        }
                    }
                ],
                "Tags": [
                    {
                        "Key": "Application",
                        "PropagateAtLaunch": "true",
                        "Value": {
                            "Ref": "application"
                        }
                    },
                    {
                        "Key": "Costcenter",
                        "PropagateAtLaunch": "true",
                        "Value": {
                            "Ref": "costcenter"
                        }
                    },
                    {
                        "Key": "Environment",
                        "PropagateAtLaunch": "true",
                        "Value": {
                            "Ref": "environment"
                        }
                    },
                    {
                        "Key": "Group",
                        "PropagateAtLaunch": "true",
                        "Value": {
                            "Ref": "group"
                        }
                    },
                    {
                        "Key": "Name",
                        "PropagateAtLaunch": "true",
                        "Value": {
                            "Fn::Join": [
                                "",
                                [
                                    "BIG-IP Autoscale Instance: ",
                                    {
                                        "Ref": "deploymentName"
                                    }
                                ]
                            ]
                        }
                    },
                    {
                        "Key": "Owner",
                        "PropagateAtLaunch": "true",
                        "Value": {
                            "Ref": "owner"
                        }
                    }
                ],
                "VPCZoneIdentifier": {
                    "Ref": "subnets"
                }
            },
            "Type": "AWS::AutoScaling::AutoScalingGroup",
            "UpdatePolicy": {
                "AutoScalingRollingUpdate": {
                    "MaxBatchSize": "1",
                    "MinInstancesInService": "1",
                    "PauseTime": "PT30M"
                }
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "1a0fb077-447c-47a6-ac90-21f96dabaa63"
                }
            }
        }
