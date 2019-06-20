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
