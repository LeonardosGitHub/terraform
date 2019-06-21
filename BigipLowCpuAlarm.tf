/*
{
    "DependsOn": "BigipAutoscaleGroup",
    "Properties": {
        "ActionsEnabled": "true",
        "AlarmActions": [
            {
                "Ref": "BigipScaleDownPolicy"
            }
        ],
        "AlarmDescription": "CPU usage percentage below average threshold after 10 successive interval of 5 minutes",
        "ComparisonOperator": "LessThanThreshold",
        "EvaluationPeriods": "10",
        "MetricName": "tmm-stat",
        "Namespace": {
            "Ref": "BigipAutoscaleGroup"
        },
        "Period": "300",
        "Statistic": "Average",
        "Threshold": {
            "Ref": "lowCpuThreshold"
        }
    },
    "Type": "AWS::CloudWatch::Alarm",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "id": "5cdb2f45-dcae-4af6-bf00-edc08cbe7d2f"
        }
    }
}
*/
