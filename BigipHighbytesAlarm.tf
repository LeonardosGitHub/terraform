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
        "AlarmDescription": "Throughput exceeds average threshold after 1 successive interval of 1 minute",
        "ComparisonOperator": "GreaterThanThreshold",
        "EvaluationPeriods": "1",
        "MetricName": "throughput-per-sec",
        "Namespace": {
            "Ref": "BigipAutoscaleGroup"
        },
        "Period": "60",
        "Statistic": "Average",
        "Threshold": {
            "Ref": "scaleUpBytesThreshold"
        }
    },
    "Type": "AWS::CloudWatch::Alarm",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "id": "f214dfab-2b70-446b-933e-0115468798b9"
        }
    }
}
*/
