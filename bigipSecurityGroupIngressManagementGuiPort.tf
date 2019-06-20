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
