{
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
