{
            "Properties": {
                "GroupDescription": "Public or External interface rules, including BIG-IP management",
                "SecurityGroupIngress": [
                    {
                        "CidrIp": {
                            "Ref": "restrictedSrcAddress"
                        },
                        "FromPort": "22",
                        "IpProtocol": "tcp",
                        "ToPort": "22"
                    },
                    {
                        "CidrIp": {
                            "Ref": "restrictedSrcAddress"
                        },
                        "FromPort": {
                            "Ref": "managementGuiPort"
                        },
                        "IpProtocol": "tcp",
                        "ToPort": {
                            "Ref": "managementGuiPort"
                        }
                    },
                    {
                        "CidrIp": {
                            "Ref": "restrictedSrcAddressApp"
                        },
                        "FromPort": "80",
                        "IpProtocol": "tcp",
                        "ToPort": "80"
                    },
                    {
                        "CidrIp": {
                            "Ref": "restrictedSrcAddressApp"
                        },
                        "FromPort": "443",
                        "IpProtocol": "tcp",
                        "ToPort": "443"
                    }
                ],
                "Tags": [
                    {
                        "Key": "Application",
                        "Value": {
                            "Ref": "application"
                        }
                    },
                    {
                        "Key": "Costcenter",
                        "Value": {
                            "Ref": "costcenter"
                        }
                    },
                    {
                        "Key": "Environment",
                        "Value": {
                            "Ref": "environment"
                        }
                    },
                    {
                        "Key": "Group",
                        "Value": {
                            "Ref": "group"
                        }
                    },
                    {
                        "Key": "Name",
                        "Value": {
                            "Fn::Join": [
                                "",
                                [
                                    "Bigip Security Group: ",
                                    {
                                        "Ref": "AWS::StackName"
                                    }
                                ]
                            ]
                        }
                    },
                    {
                        "Key": "Owner",
                        "Value": {
                            "Ref": "owner"
                        }
                    }
                ],
                "VpcId": {
                    "Ref": "Vpc"
                }
            },
            "Type": "AWS::EC2::SecurityGroup",
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "e8897066-c304-4ca7-803b-61c16f532ca2"
                }
            }
        }
