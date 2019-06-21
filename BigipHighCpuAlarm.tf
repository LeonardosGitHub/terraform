/*
{
    "DependsOn": "BigipAutoscaleGroup",
    "Properties": {
        "ActionsEnabled": "true",
        "AlarmActions": [
            {
                "Ref": "BigipScaleUpPolicy"
            }
        ],
        "AlarmDescription": "CPU usage percentage exceeds average threshold after 1 successive interval of 1 minute",
        "ComparisonOperator": "GreaterThanThreshold",
        "EvaluationPeriods": "1",
        "MetricName": "tmm-stat",
        "Namespace": {
            "Ref": "BigipAutoscaleGroup"
        },
        "Period": "60",
        "Statistic": "Average",
        "Threshold": {
            "Ref": "highCpuThreshold"
        }
    },
    "Type": "AWS::CloudWatch::Alarm",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "id": "d7559e82-3245-4f30-959d-a62c28e8aebb"
        }
    }
}
*/
