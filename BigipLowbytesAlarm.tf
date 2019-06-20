{
            "DependsOn": "BigipAutoscaleGroup",
            "Properties": {
                "ActionsEnabled": "true",
                "AlarmActions": [
                    {
                        "Ref": "BigipScaleDownPolicy"
                    }
                ],
                "AlarmDescription": "Throughput below average threshold for 10 successive intervals of 5 minutes",
                "ComparisonOperator": "LessThanThreshold",
                "EvaluationPeriods": "10",
                "MetricName": "throughput-per-sec",
                "Namespace": {
                    "Ref": "BigipAutoscaleGroup"
                },
                "Period": "300",
                "Statistic": "Average",
                "Threshold": {
                    "Ref": "scaleDownBytesThreshold"
                }
            },
            "Type": "AWS::CloudWatch::Alarm",
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "1eae43be-6f77-40ac-a6b8-37e30966d8e7"
                }
            }
        }
