/*
{
    "Properties": {
        "AdjustmentType": "ChangeInCapacity",
        "AutoScalingGroupName": {
            "Ref": "BigipAutoscaleGroup"
        },
        "Cooldown": "1500",
        "ScalingAdjustment": "1"
    },
    "Type": "AWS::AutoScaling::ScalingPolicy",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "id": "5308f171-6009-4eb5-a392-716c81c093c7"
        }
    }
}
*/
resource "aws_autoscaling_policy" "BigipScaleUpPolicy" {
  name                   = "waf-${var.fqdn_app_name}-${var.deploymentName}-ScaleUpPolicy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 1500
  autoscaling_group_name = "${aws_autoscaling_group.BigipAutoscaleGroup.name}"
}




