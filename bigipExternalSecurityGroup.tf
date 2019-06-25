
resource "aws_security_group" "bigipexternalsecuritygroup" {
  name   = "waf-${var.fqdn_app_name}-${var.deploymentName}-SecGroupExternal"
  vpc_id = aws_vpc.vpc-example.id

  #bigipExternalSecurityGroup
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.restrictedSrcAddress
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.restrictedSrcAddress
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.restrictedSrcAddress
  }

  ingress {
    from_port   = var.managementGuiPort
    to_port     = var.managementGuiPort
    protocol    = "tcp"
    cidr_blocks = var.restrictedSrcAddress
  }

  #bigipSecurityGroupIngressManagementGuiPort
  ingress {
    from_port = var.managementGuiPort
    to_port   = var.managementGuiPort
    protocol  = "tcp"
    self      = true
  }
  #bigipSecurityGroupIngressConfigSync
  ingress {
    from_port = 4353
    to_port   = 4353
    protocol  = "tcp"
    self      = true
  }
  #bigipSecurityGroupIngressAsmPolicySync
  ingress {
    from_port = 6123
    to_port   = 6128
    protocol  = "tcp"
    self      = true
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "waf-${var.fqdn_app_name}-${var.deploymentName}-SecGroupExternal"
  }
}


/*
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
{
    "Properties": {
        "FromPort": 6123,
        "GroupId": {
            "Ref": "bigipExternalSecurityGroup"
        },
        "IpProtocol": "tcp",
        "SourceSecurityGroupId": {
            "Ref": "bigipExternalSecurityGroup"
        },
        "ToPort": 6128
    },
    "Type": "AWS::EC2::SecurityGroupIngress",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "id": "24ddc1d5-74c7-4ee9-b781-0e434d82ffce"
        }
    }
}
    "Properties": {
        "FromPort": 4353,
        "GroupId": {
            "Ref": "bigipExternalSecurityGroup"
        },
        "IpProtocol": "tcp",
        "SourceSecurityGroupId": {
            "Ref": "bigipExternalSecurityGroup"
        },
        "ToPort": 4353
    },
    "Type": "AWS::EC2::SecurityGroupIngress",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "id": "e839de54-09c5-4b3f-a34e-bd605d0b3065"
        }
    }
}
bigipSecurityGroupIngressManagementGuiPort
{
    "Properties": {
        "FromPort": {
            "Ref": "managementGuiPort"
        },
        "GroupId": {
            "Ref": "bigipExternalSecurityGroup"
        },
        "IpProtocol": "tcp",
        "SourceSecurityGroupId": {
            "Ref": "bigipExternalSecurityGroup"
        },
        "ToPort": {
            "Ref": "managementGuiPort"
        }
    },
    "Type": "AWS::EC2::SecurityGroupIngress",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "id": "f4722da0-ca54-49da-92c4-fd6649c31f91"
        }
    }
}
*/
